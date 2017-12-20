#include replication library 
. "$PSScriptRoot/replication.ps1"

$publisher = "DESKTOP-TEOD82V\SUBSCRIBER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR2"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER2"
$distributionDB = "distribution"

$publicationDB = "AdventureWorks2014"
$publication = "AdventureWorks2014Publication"
$subscriptionDB = $publicationDB
$masterDB = "master"

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
    #@{ SqlFilePath = "$sqlScriptDirectory/drop-publisher-on-distributor.sql"; Instance = $distributor; Database = $distributionDB; } 
    @{ SqlFilePath = "$sqlScriptDirectory/drop-replication-on-distributor.sql"; Instance = $distributor; Database = $masterDB; } 
)

$query = "SELECT spid FROM sys.sysprocesses WHERE dbid = db_id('$distributorDB')"
$result = Invoke-Sqlcmd -Query $query -ServerInstance $distributor -ErrorAction Stop -Database $masterDb
$result | ForEach-Object { 
    $query = "KILL $($_.spid);"
    Invoke-Sqlcmd -Query $query -ServerInstance $distributor -ErrorAction Stop -Database $masterDb
} 

$stepVariables | ForEach-Object {
    Invoke-Query -Instance $_.Instance -Database $_.Database -SqlFilePath $_.SqlFilePath -Variables $variables
}