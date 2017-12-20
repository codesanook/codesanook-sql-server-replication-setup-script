#include replication library 
. "$PSScriptRoot/replication.ps1"

$publisher = "DESKTOP-TEOD82V\PUBLISHER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER"
New-Replication -Publisher $publisher -Distributor $distributor -Subscriber $subscriber


$publisher = "DESKTOP-TEOD82V\SUBSCRIBER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR2"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER2"
#New-Replication -Publisher $publisher -Distributor $distributor -Subscriber $subscriber

