$distributionDB = "distribution"
# We execute SQL PowerShell from external network so we need to use localhost with external port .
$publisherInstance = "localhost,1433"
$distributorInstance = "localhost,1434"
$subscriberInstance = "localhost,1435"

# Windows account used to run the Log Reader and distribution Agents.

function Install-Replication {
    param(
        [Parameter(Mandatory = $true)] [string] $Publisher,
        [Parameter(Mandatory = $true)] [string] $Distributor,
        [Parameter(Mandatory = $true)] [string] $Subscriber,
        [Parameter(Mandatory = $true)] [string] $Username,
        [Parameter(Mandatory = $true)] [SecureString] $Password,
        [Parameter(Mandatory = $true)] [string] $PublicationDB,
        [Parameter(Mandatory = $true)] [string] $ArticleTable,
        [Parameter(Mandatory = $true)] [string] $ArticleStoredProc
    )

    $jobPassword =  $plainTextPassword
    $publication = "$($PublicationDB)Publication"
    $subscriptionDB = $PublicationDB

    $backupDBDirectory = "/var/opt/mssql/backup"
    $restoreDBDirectory = "/var/opt/mssql/backup"

    $sqlScriptDirectory = "$PSScriptRoot/create-replication"
    $plainTextPassword = Get-PlainTextPassword -Password $Password
    $sharedVariables = @(
        "distributor=$Distributor"
        "distributionDB=$distributionDB"
        "distributorPassword=$plainTextPassword" # A password of distributor_admin

        "publisher=$Publisher" 
        "publicationDB=$PublicationDB"
        "publication=$publication"

        "username=$username"
        "password=$plainTextPassword"
        "articleTable=$ArticleTable"
        "articleStoredProc=$ArticleStoredProc"

        "backupDBName=$PublicationDB"
        "backupDBDirectory=$backupDBDirectory"
        "restoreDBDirectory=$restoreDBDirectory"
        "subscriber=$Subscriber"
        "subscriptionDB=$subscriptionDB"
    )   

    $stepVariables = @(
        @{ SqlFilePath = "$sqlScriptDirectory/configure-distributor.sql"; Instance = $distributorInstance; Database = 'master'; } 
        @{ SqlFilePath = "$sqlScriptDirectory/create-distribution-database.sql"; Instance = $distributorInstance; Database = 'master'; } 
        @{ SqlFilePath = "$sqlScriptDirectory/configure-publisher-to-use-distribution-database.sql"; Instance = $distributorInstance; Database = 'master'; }
        @{ SqlFilePath = "$sqlScriptDirectory/configure-remote-distributor-on-publisher.sql"; Instance = $publisherInstance; Database = 'master'; }

        #@{ SqlFilePath = "$sqlScriptDirectory/create-publication-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }
        #@{ SqlFilePath = "$sqlScriptDirectory/create-table-article-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }
        #@{ SqlFilePath = "$sqlScriptDirectory/create-proc-article-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }
        #@{ SqlFilePath = "$sqlScriptDirectory/change-publication-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }

        ## Todo we may need to create a trn here
        ## From Note: You need to do a backup after the Publication was configured on the Publisher. 
        ## Otherwise the initialization from backup will not work!
        ## In http://www.sqlpassion.at/archive/2012/08/05/initialize-a-transactional-replication-from-a-database-backup/
        # and move a full backup to the top of steps 

        #@{ SqlFilePath = "$sqlScriptDirectory/disable-distribution-clean-up.sql"; Instance = $distributor; Database = 'master'; }
        #@{ SqlFilePath = "$sqlScriptDirectory/backup-full-publisher-database.sql"; Instance = $publisher; Database = 'master'; }
        #@{ SqlFilePath = "$sqlScriptDirectory/drop-create-db-on-subscriber.sql"; Instance = $subscriber; Database = 'master'; }

        #@{ SqlFilePath = "$sqlScriptDirectory/create-subscription-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }
        #@{ SqlFilePath = "$sqlScriptDirectory/enable-distribution-clean-up.sql"; Instance = $distributor; Database ='master'; }
    )

    Stop-DatabaseProcess -Instance $Publisher -Database $PublicationDB -Username $Username -Password $Password
    Stop-DatabaseProcess -Instance $Subscriber -Database $subscriptionDB -Username $Username -Password $Password
    Invoke-Steps -StepVariable $stepVariables -SharedVariables $sharedVariables -Username $Username -Password $Password
}

function Uninstall-Replication {
    param(
        [Parameter(Mandatory = $true)] [string] $Publisher,
        [Parameter(Mandatory = $true)] [string] $Distributor,
        [Parameter(Mandatory = $true)] [string] $Subscriber,
        [Parameter(Mandatory = $true)] [string] $PublicationDB,
        [Parameter(Mandatory = $true)] [string] $Username,
        [Parameter(Mandatory = $true)] [SecureString] $Password

    )
    "Distributor $Distributor"

    $publication = "$($PublicationDB)Publication"
    $subscriptionDB = $PublicationDB
    $sqlScriptDirectory = "$PSScriptRoot/drop-replication";

    $variables = @(
        "distributor=$distributor"
        "distributionDB=$distributionDB"

        "publisher=$publisher" 
        "publicationDB=$PublicationDB"
        "publication=$publication"

        "subscriber=$subscriber"
        "subscriptionDB=$subscriptionDB"
    )   

    $stepVariables = @(
        @{ SqlFilePath = "$sqlScriptDirectory/drop-publication-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; } 
        @{ SqlFilePath = "$sqlScriptDirectory/clean-replication-on-publisher.sql"; Instance = $publisher; Database = $masterDatabase; } 
        @{ SqlFilePath = "$sqlScriptDirectory/drop-replication-on-subscriber.sql"; Instance = $subscriber; Database = $masterDatabase; } 
        @{ SqlFilePath = "$sqlScriptDirectory/drop-replication-on-distributor.sql"; Instance = $distributor; Database = $masterDatabase; } 
    )

    Stop-DatabaseProcess -Instance $Distributor -Database $distributionDB -Username $Username -Password $Password
    Stop-DatabaseProcess -Instance $Publisher -Database $PublicationDB -Username $Username -Password $Password
    Stop-DatabaseProcess -Instance $Subscriber -Database $subscriptionDB -Username $Username -Password $Password
    Invoke-Steps -StepVariable $stepVariables -SqlVariables $variables -Username $Username -Password $Password
}

function Invoke-Query {
    param(
        $Instance, 
        $Database,
        $Username,
        [SecureString] $Password,
        $Query,
        $SqlFilePath, 
        $Variables
    )

    "Current working database: $DataBase"

    Push-Location
    # https://docs.microsoft.com/en-us/sql/powershell/invoke-sqlcmd-cmdlet
    if ($Query) {
        Invoke-Sqlcmd `
            -ServerInstance $Instance `
            -Database $Database `
            -Username $Username `
            -Password (Get-PlainTextPassword $Password) `
            -Query $Query `
            -Variable $Variables `
            -ErrorAction Stop
    }
    else {
        Invoke-Sqlcmd `
            -ServerInstance $Instance `
            -Database $Database `
            -Username $Username `
            -Password (Get-PlainTextPassword $Password) `
            -InputFile $SqlFilePath `
            -Variable $Variables `
            -ErrorAction Stop
    }
    Pop-Location
}

function Invoke-Steps {
    param(
        $StepVariables, 
        $SharedVariables,
        $Username,
        [SecureString] $Password
    )

    $StepVariables | ForEach-Object {
        $step = $_
        try {
            "Executing $($step.SqlFilePath)"
            Invoke-Query `
                -Instance $step.Instance `
                -Database $step.Database `
                -SqlFilePath $step.SqlFilePath `
                -Variables $SharedVariables `
                -Username $Username `
                -Password $Password
        }
        catch {
            "Error occured when executing $($step.SqlFilePath)"
            $_.Exception.Message
        }
    }
}

function Stop-DatabaseProcess() {
    param(
        $Instance, 
        $Database,
        $Username, 
        [SecureString] $Password
    )
    Push-Location

    $query = "SELECT spid FROM sys.sysprocesses WHERE dbid = db_id('$Database')"
    $result = Invoke-Sqlcmd `
        -Query $query `
        -ServerInstance $Instance `
        -Database "master" `
        -Username $Username `
        -Password (Get-PlainTextPassword $Password) `
        -ErrorAction Stop

    $result | ForEach-Object { 
        $query = "KILL $($_.spid);"
        Invoke-Sqlcmd `
            -Query $query `
            -ServerInstance $Instance `
            -Database "master" `
            -Username $Username `
            -Password (Get-PlainTextPassword $Password) `
            -ErrorAction Stop
        "Process ID $($_.spid) killed"
    } 

    Pop-Location
    "Remove all processes on $Database database"
}

function Get-PlainTextPassword {
    param(
        [Parameter(Mandatory = $true)] [SecureString] $Password
    )

    $binaryString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $plainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($binaryString)
    $plainTextPassword
}

Export-ModuleMember -Function Stop-DatabaseProcess
Export-ModuleMember -Function Invoke-Query
Export-ModuleMember -Function Install-Replication
Export-ModuleMember -Function Uninstall-Replication
Export-ModuleMember -Function Get-PlainTextPassword