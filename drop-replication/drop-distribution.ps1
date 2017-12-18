
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
<#
$path = "$PSScriptRoot\1. drop-replication-on-publisher.sql"
Invoke-Query -FilePath $path -Instance $publisher -Database $replicatedDb
#>


# $path = "$PSScriptRoot\1. clean-replication-on-publisher.sql"
# Invoke-Query -FilePath $path -Instance $publisher -Database $masterDb

<#
$path = "$PSScriptRoot\2. drop-replication-on-subscriber.sql"
Invoke-Query -FilePath $path -Instance $subscriber -Database $masterDb
#>


$query = "SELECT spid FROM sys.sysprocesses WHERE dbid = db_id('distribution')"
$result = Invoke-Sqlcmd -Query $query -ServerInstance $distributor -ErrorAction Stop -Database $masterDb
$result | ForEach-Object { 
    $query = "KILL $($_.spid);"
    Invoke-Sqlcmd -Query $query -ServerInstance $distributor -ErrorAction Stop -Database $masterDb
} 

$path = "$PSScriptRoot\3. drop-replication-on-distributor.sql"
Invoke-Query -FilePath $path -Instance $distributor -Database $masterDb