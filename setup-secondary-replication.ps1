#include replication library 
. "$PSScriptRoot/replication.ps1"

$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR2"
$distributionDb = "distribution"
$distributorPassword = "12345"

$publisher = "DESKTOP-TEOD82V\SUBSCRIBER"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER2"
$masterDb = "master"

$replicatedDb = "AdventureWorks2014"
$msdbDb = "msdb"

$sqlScriptDirectory = "$PSScriptRoot/create-replication";

$variables =  @(
    "distributor=$distributor",
    "distributionDb=$distributionDb",
    "distributorPassword= $distributorPassword",

    "publisher=$publisher" 
    )   

$stepVariables = @(
    #@{ Instance = $distributor; Database = $masterDb; SqlFilePath = "$sqlScriptDirectory/create-distributor.sql"; } 
    #@{ Instance = $distributor; Database = $distributionDb; SqlFilePath = "$sqlScriptDirectory/add-publisher-on-distributor.sql"; }
    #@{ Instance = $publisher; Database = $masterDb; SqlFilePath = "$sqlScriptDirectory/add-distributor-on-publisher.sql"; }
 )

$stepVariables | ForEach-Object {
    Invoke-Query -Instance $_.Instance -Database $_.Database -SqlFilePath $_.SqlFilePath -Variables $variables
}


<#
$path = "$PSScriptRoot\3. create-publication-on-publisher.sql"
Invoke-Query -FilePath $path -Instance $publisher -Database $replicatedDb

$path = "$PSScriptRoot\4. create-article-on-publisher.sql"
Invoke-Query -FilePath $path -Instance $publisher -Database $replicatedDb

try {
    $path = "$PSScriptRoot\5. disable-distribution-clean-up.sql"
    Invoke-Query -FilePath $path -Instance $distributor -Database $msdbDb
}
catch {

}

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