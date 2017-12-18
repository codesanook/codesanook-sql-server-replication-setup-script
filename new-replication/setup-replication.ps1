$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR"
$publisher = "DESKTOP-TEOD82V\PUBLISHER"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER"
$masterDb = "master"
$distributionDb = "distribution"
$replicatedDb = "AdventureWorks2014"
$msdbDb = "msdb"

function Invoke-Query($FilePath, $Instance, $Database) {
    $query = Get-Content -Path $filePath | Out-String
    Invoke-Sqlcmd -Query $query -ServerInstance $instance -Database $database -ErrorAction Stop
}

$query = Get-Content -Path "$PSScriptRoot\1. create-distributor.sql" | Out-String
Invoke-Sqlcmd -Query $query -ServerInstance "DESKTOP-TEOD82V\DISTRIBUTOR" -Database "master"

$query  = Get-Content -Path "$PSScriptRoot\2. add-publisher-on-distributor.sql" | Out-String
Invoke-Sqlcmd -Query $query -ServerInstance "DESKTOP-TEOD82V\DISTRIBUTOR" -Database "distribution"

$path = "$PSScriptRoot\2. add-distributor-on-publisher.sql"
Invoke-Query -FilePath $path -Instance $publisher -Database $masterDb 

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