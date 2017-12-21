#include replication library 
. "$PSScriptRoot/replication.ps1"

#setup group 1 replication
$publisher = "DESKTOP-TEOD82V\PUBLISHER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER"
New-Replication -Publisher $publisher -Distributor $distributor -Subscriber $subscriber

Start-Sleep -Seconds 15

#setup group 2 replication
$publisher = "DESKTOP-TEOD82V\SUBSCRIBER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR2"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER2"
#New-Replication -Publisher $publisher -Distributor $distributor -Subscriber $subscriber

Write-Host "Set up replication successfully"