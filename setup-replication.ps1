#include replication library 
. "$PSScriptRoot/replication.ps1"

$publisher = "DESKTOP-TEOD82V\SUBSCRIBER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR2"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER2"

$distributionDB = "distribution"
$distributorPassword = "12345"

$publicationDB = "AdventureWorks2014"
$publication = "AdventureWorks2014Publication"
$subscriptionDB = $publicationDB
$masterDB = "master"
$msdbDB = "msdb"

# Windows account used to run the Log Reader and Snapshot Agents.
$jobLogin = "DESKTOP-TEOD82V\aaron"
$jobPassword = "12345"
$articleTable = "Users" #dbo.Users

$backupDBName = $publicationDB 
$backupDBDirectory = 'C:\backup-db\SUBSCRIBER\' #must be ending with \ for now 
$restoreDBDirectory = 'C:\db\SUBSCRIBER\'  #must be ending with \ for now 

New-Item -ItemType Directory -Force -Path $backupDBDirectory | Out-Null
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
    @{ SqlFilePath = "$sqlScriptDirectory/create-article-on-publisher.sql"; Instance = $publisher; Database = $publicationDB; }

    @{ SqlFilePath = "$sqlScriptDirectory/disable-distribution-clean-up.sql"; Instance = $distributor; Database = $msdbDB; }
    @{ SqlFilePath = "$sqlScriptDirectory/backup-full-publisher-database.sql"; Instance = $publisher; Database = $masterDB; }
    @{ SqlFilePath = "$sqlScriptDirectory/drop-create-db-on-subscriber.sql"; Instance = $subscriber; Database = $masterDB; }
    @{ SqlFilePath = "$sqlScriptDirectory/create-subscription-on-publisher.sql"; Instance = $publisher; Database = $publicationDB; }
    @{ SqlFilePath = "$sqlScriptDirectory/enable-distribution-clean-up.sql"; Instance = $distributor; Database = $msdbDB; }
)

$stepVariables | ForEach-Object {
    Invoke-Query -Instance $_.Instance -Database $_.Database -SqlFilePath $_.SqlFilePath -Variables $variables
}