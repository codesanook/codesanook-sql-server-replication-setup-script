# shared variables
$distributionDB = "distribution"
$distributorPassword = "12345"

$masterDB = "master"
$msdbDB = "msdb"

# Windows account used to run the Log Reader and distribution Agents.
$jobLogin = "sa"
$jobPassword = "12345"

function New-Replication {
    param(
        [Parameter(Mandatory = $true)] [string] $Publisher,
        [Parameter(Mandatory = $true)] [string] $Distributor,
        [Parameter(Mandatory = $true)] [string] $Subscriber,
        [Parameter(Mandatory = $true)] [string] $PublicationDB,
        [Parameter(Mandatory = $true)] [string] $ArticleTable,
        [Parameter(Mandatory = $true)] [string] $ArticleStoredProc
    )

    $publication = "$($PublicationDB)Publication"
    $subscriptionDB = $PublicationDB

    [Regex]$regex = "[\w\-]+\\(?<instanceName>\w+)"
    $match = $regex.Match($Publisher)
    if ($match.Success) {
        $instanceName = $match.Groups["instanceName"]
    }

    $backupDBDirectory = "C:\backup-db\$instanceName\" #must be ending with \ for now 
    $restoreDBDirectory = "C:\data-db\$instanceName\"  #must be ending with \ for now 
    New-Item -ItemType Directory -Force -Path $backupDBDirectory | Out-Null

    #SQL server not override existing backup files
    Remove-Item "$backupDBDirectory*" 
    New-Item -ItemType Directory -Force -Path $restoreDBDirectory | Out-Null

    $sqlScriptDirectory = "$PSScriptRoot/create-replication";
    $variables = @(
        "distributor=$distributor"
        "distributionDB=$distributionDB"
        "distributorPassword= $distributorPassword"

        "publisher=$publisher" 
        "publicationDB=$PublicationDB"
        "publication=$publication"

        "jobLogin=$jobLogin"
        "jobPassword=$jobPassword"
        "articleTable=$ArticleTable"
        "articleStoredProc=$ArticleStoredProc"

        "backupDBName=$PublicationDB"
        "backupDBDirectory=$backupDBDirectory"
        "restoreDBDirectory=$restoreDBDirectory"
        "subscriber=$subscriber"
        "subscriptionDB=$subscriptionDB"
    )   

    $stepVariables = @(
        @{ SqlFilePath = "$sqlScriptDirectory/create-distributor.sql"; Instance = $distributor; Database = $masterDB; } 
        @{ SqlFilePath = "$sqlScriptDirectory/add-publisher-on-distributor.sql"; Instance = $distributor; Database = $distributionDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/add-distributor-on-publisher.sql"; Instance = $publisher; Database = $masterDB; }

        @{ SqlFilePath = "$sqlScriptDirectory/create-publication-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/create-table-article-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/create-proc-article-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/change-publication-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }

        # Todo we may need to create a trn here
        # From Note: You need to do a backup after the Publication was configured on the Publisher. 
        # Otherwise the initialization from backup will not work!
        # In http://www.sqlpassion.at/archive/2012/08/05/initialize-a-transactional-replication-from-a-database-backup/
        # and move a full backup to the top of steps 

        @{ SqlFilePath = "$sqlScriptDirectory/disable-distribution-clean-up.sql"; Instance = $distributor; Database = $msdbDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/backup-full-publisher-database.sql"; Instance = $publisher; Database = $masterDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/drop-create-db-on-subscriber.sql"; Instance = $subscriber; Database = $masterDB; }

        @{ SqlFilePath = "$sqlScriptDirectory/create-subscription-on-publisher.sql"; Instance = $publisher; Database = $PublicationDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/enable-distribution-clean-up.sql"; Instance = $distributor; Database = $msdbDB; }
    )

    Clear-DatabaseProcess -Instance $Publisher -Database $PublicationDB
    Clear-DatabaseProcess -Instance $Subscriber -Database $subscriptionDB

    Invoke-Steps -StepVariable $stepVariables -SqlVariables $variables
}

function Remove-Replication {
    param(
        [Parameter(Mandatory = $true)] [string] $Publisher,
        [Parameter(Mandatory = $true)] [string] $Distributor,
        [Parameter(Mandatory = $true)] [string] $Subscriber,
        [Parameter(Mandatory = $true)] [string] $PublicationDB
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
        @{ SqlFilePath = "$sqlScriptDirectory/clean-replication-on-publisher.sql"; Instance = $publisher; Database = $masterDB; } 
        @{ SqlFilePath = "$sqlScriptDirectory/drop-replication-on-subscriber.sql"; Instance = $subscriber; Database = $masterDB; } 
        @{ SqlFilePath = "$sqlScriptDirectory/drop-replication-on-distributor.sql"; Instance = $distributor; Database = $masterDB; } 
    )

    Stop-DatabaseProcess -Instance $Distributor -Database $distributionDB
    Stop-DatabaseProcess -Instance $Publisher -Database $PublicationDB
    Stop-DatabaseProcess -Instance $Subscriber -Database $subscriptionDB
    Invoke-Steps -StepVariable $stepVariables -SqlVariables $variables
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
        $tepVariables, 
        $SqlVariables
    )

    $StepVariables | ForEach-Object {
        $step = $_
        try {
            "Executing $($step.SqlFilePath)"
            Invoke-Query -Instance $step.Instance -Database $step.Database -SqlFilePath $step.SqlFilePath -Variables $SqlVariables 
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
        [SecureString] $Password
    )

    $binaryString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $plainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($binaryString)
    $plainTextPassword
}

Export-ModuleMember -Function Stop-DatabaseProcess
Export-ModuleMember -Function Invoke-Query