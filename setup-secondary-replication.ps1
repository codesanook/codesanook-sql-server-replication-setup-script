#include replication library 
. "$PSScriptRoot/replication.ps1"

$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR2"
$distributionDB = "distribution"
$distributorPassword = "12345"

$publisher = "DESKTOP-TEOD82V\SUBSCRIBER"
$publicationDB = "AdventureWorks2014"
$publication = "AdventureWorks2014Publication"

# Windows account used to run the Log Reader and Snapshot Agents.
$jobLogin = "DESKTOP-TEOD82V\aaron"
$jobPassword = "12345"
$articleTable = "Users" #dbo.Users

$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER2"
$masterDB = "master"
$msdbDB = "msdb"

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
    "articleTable=$articleTable"
)   

$stepVariables = @(
    #@{ Instance = $distributor; Database = $masterDB; SqlFilePath = "$sqlScriptDirectory/create-distributor.sql"; } 
    #@{ Instance = $distributor; Database = $distributionDB; SqlFilePath = "$sqlScriptDirectory/add-publisher-on-distributor.sql"; }
    #@{ Instance = $publisher; Database = $masterDB; SqlFilePath = "$sqlScriptDirectory/add-distributor-on-publisher.sql"; }
    #@{ Instance = $publisher; Database = $publicationDB; SqlFilePath = "$sqlScriptDirectory/create-publication-on-publisher.sql"; }
    #@{ SqlFilePath = "$sqlScriptDirectory/create-article-on-publisher.sql"; Instance = $publisher; Database = $publicationDB; }
    #@{ SqlFilePath = "$sqlScriptDirectory/disable-distribution-clean-up.sql"; Instance = $distributor; Database = $msdbDB; }
)

$stepVariables | ForEach-Object {
    Invoke-Query -Instance $_.Instance -Database $_.Database -SqlFilePath $_.SqlFilePath -Variables $variables
}

<#

#give a fullbackup name variable
$path = "$PSScriptRoot\6. backup-full-publisher-database.sql"
Invoke-Query -FilePath $path -Instance $publisher -Database $replicatedDb 

$path = "$PSScriptRoot\7. drop-create-db-on-subscriber.sql"
Invoke-Query -FilePath $path -Instance $subscriber -Database $masterDb 

$path = "$PSScriptRoot\8. create-subscription-on-publisher.sql"
Invoke-Query -FilePath $path -Instance $publisher -Database $replicatedDb 


try{
    $path = "$PSScriptRoot\9. enable-distribution-clean-up.sql"
    Invoke-Query -FilePath $path -Instance $distributor -Database $msdbDb 
}
catch {

}
#>