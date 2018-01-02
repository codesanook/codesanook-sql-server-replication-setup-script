#include replication library 
. "$PSScriptRoot/replication.ps1"

#uninstall group 2 replication
$publisher = "DESKTOP-TEOD82V\SUBSCRIBER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR2"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER2"
#Remove-Replication -Publisher $publisher -Distributor $distributor -Subscriber $subscriber

Start-Sleep -Seconds 15

#uninstall group 1 replication
$publisher = "DESKTOP-TEOD82V\PUBLISHER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER"
Remove-Replication -Publisher $publisher -Distributor $distributor -Subscriber $subscriber

Write-Host "Uninstalled replication successfully"