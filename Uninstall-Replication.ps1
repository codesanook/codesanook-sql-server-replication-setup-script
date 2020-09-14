#include replication library 
. "$PSScriptRoot/replication.ps1"

$arguments = @{
    Publisher = "DESKTOP-TEOD82V\PUBLISHER"
    Subscriber = "DESKTOP-TEOD82V\SUBSCRIBER"
    Distributor = "DESKTOP-TEOD82V\DISTRIBUTOR"
    PublicationDB = "ThingsToDo" 
}

Uninstall-Replication @arguments 
"Uninstalled replication successfully"