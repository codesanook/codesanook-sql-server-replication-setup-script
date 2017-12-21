
#shared variable 
$distributionDB = "distribution"
$distributorPassword = "12345"

$publicationDB = "MyStartup"
$publication = "$($publicationDB)Publication"
$subscriptionDB = $publicationDB
$masterDB = "master"
$msdbDB = "msdb"

# Windows account used to run the Log Reader and Snapshot Agents.
$jobLogin = "DESKTOP-TEOD82V\aaron"
$jobPassword = "12345"
$articleTable = "Users" #dbo.Users
$articleStoredProc = "insertUser" #dbo.insertUser stored proc
$backupDBName = $publicationDB 

function Invoke-Query($Instance, $Database, $SqlFilePath, $Variables) {
    Push-Location
    #https://docs.microsoft.com/en-us/sql/powershell/invoke-sqlcmd-cmdlet
    Invoke-Sqlcmd -ServerInstance $Instance -Database $Database -InputFile $SqlFilePath -Variable $Variables -ErrorAction Stop
    Pop-Location
}

function Invoke-Steps($StepVariables, $SqlVariables) {
    $StepVariables | ForEach-Object {
        Invoke-Query -Instance $_.Instance -Database $_.Database -SqlFilePath $_.SqlFilePath -Variables $SqlVariables 
    }
}

function New-Replication {
    param(
        [Parameter(Mandatory = $true)] [string] $Publisher,
        [Parameter(Mandatory = $true)] [string] $Distributor,
        [Parameter(Mandatory = $true)] [string] $Subscriber
    )

    [regex]$regex = "[\w\-]+\\(?<instanceName>\w+)"
    $input = $publisher
        
    $match = $regex.Match($input)
    if ($match.Success) {
        $instanceName = $match.Groups["instanceName"]
    }

    $backupDBDirectory = "C:\backup-db\$instanceName\" #must be ending with \ for now 
    #"backupDBDirectory $backupDBDirectory"

    $restoreDBDirectory = "C:\data-db\$instanceName\"  #must be ending with \ for now 
    New-Item -ItemType Directory -Force -Path $backupDBDirectory | Out-Null
    #SQL server not override existing backup files
    Remove-Item "$backupDBDirectory*" 

    New-Item -ItemType Directory -Force -Path $restoreDBDirectory | Out-Null

    $sqlScriptDirectory = "$PSScriptRoot/create-replication";

    $variables = @(
        "distributor=$distributor",
        "distributionDB=$distributionDB",
        "distributorPassword= $distributorPassword",

        "publisher=$publisher", 
        "publicationDB=$publicationDB",
        "publication=$publication",

        "jobLogin=$jobLogin",
        "jobPassword=$jobPassword",
        "articleTable=$articleTable",
        "articleStoredProc=$articleStoredProc"

        "backupDBName=$backupDBName",
        "backupDBDirectory=$backupDBDirectory",
        "restoreDBDirectory=$restoreDBDirectory",
        "subscriber=$subscriber",
        "subscriptionDB=$subscriptionDB"
    )   

    $stepVariables = @(
        @{ SqlFilePath = "$sqlScriptDirectory/create-distributor.sql"; Instance = $distributor; Database = $masterDB; } 
        @{ SqlFilePath = "$sqlScriptDirectory/add-publisher-on-distributor.sql"; Instance = $distributor; Database = $distributionDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/add-distributor-on-publisher.sql"; Instance = $publisher; Database = $masterDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/create-publication-on-publisher.sql"; Instance = $publisher; Database = $publicationDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/create-articles-on-publisher.sql"; Instance = $publisher; Database = $publicationDB; }

        #todo we may need to create a trn here
        #from Note: You need to do a backup after the Publication was configured on the Publisher. Otherwise the initialization from backup will not work!
        #in http://www.sqlpassion.at/archive/2012/08/05/initialize-a-transactional-replication-from-a-database-backup/
        #and move create a full backup to the top of steps 

        @{ SqlFilePath = "$sqlScriptDirectory/disable-distribution-clean-up.sql"; Instance = $distributor; Database = $msdbDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/backup-full-publisher-database.sql"; Instance = $publisher; Database = $masterDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/drop-create-db-on-subscriber.sql"; Instance = $subscriber; Database = $masterDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/create-subscription-on-publisher.sql"; Instance = $publisher; Database = $publicationDB; }
        @{ SqlFilePath = "$sqlScriptDirectory/enable-distribution-clean-up.sql"; Instance = $distributor; Database = $msdbDB; }
    )

    Clear-DatabaseProcess -Instance $Subscriber -Database $publicationDB
    Invoke-Steps -StepVariable $stepVariables -SqlVariables $variables
}

function Remove-Replication {
    param(
        [Parameter(Mandatory = $true)] [string] $Publisher,
        [Parameter(Mandatory = $true)] [string] $Distributor,
        [Parameter(Mandatory = $true)] [string] $Subscriber
    )

    $sqlScriptDirectory = "$PSScriptRoot/drop-replication";

    $variables = @(
        "distributor=$distributor",
        "distributionDB=$distributionDB",

        "publisher=$publisher", 
        "publicationDB=$publicationDB",
        "publication=$publication",

        "subscriber=$subscriber",
        "subscriptionDB=$subscriptionDB"
    )   

    $stepVariables = @(
        @{ SqlFilePath = "$sqlScriptDirectory/drop-replication-publication-on-publisher.sql"; Instance = $publisher; Database = $publicationDB; } 
        @{ SqlFilePath = "$sqlScriptDirectory/clean-replication-on-publisher.sql"; Instance = $publisher; Database = $masterDB; } 
        @{ SqlFilePath = "$sqlScriptDirectory/drop-replication-on-subscriber.sql"; Instance = $subscriber; Database = $masterDB; } 
        @{ SqlFilePath = "$sqlScriptDirectory/drop-replication-on-distributor.sql"; Instance = $distributor; Database = $masterDB; } 
    )

    Clear-DatabaseProcess -Instance $Publisher -Database $publicationDB
    Clear-DatabaseProcess -Instance $Distributor -Database $distributionDB
    Clear-DatabaseProcess -Instance $Subscriber -Database $publicationDB

    Invoke-Steps -StepVariable $stepVariables -SqlVariables $variables
}

function Clear-DatabaseProcess($Instance, $Database) {
    Push-Location

    $query = "SELECT spid FROM sys.sysprocesses WHERE dbid = db_id('$Database')"
    $result = Invoke-Sqlcmd -Query $query -ServerInstance $Instance -ErrorAction Stop -Database $masterDB
    $result | ForEach-Object { 
        $query = "KILL $($_.spid);"
        Invoke-Sqlcmd -Query $query -ServerInstance $Instance -ErrorAction Stop -Database $masterDB
        Write-Host "killed process id $($_.spid)"
    } 

    Pop-Location
}