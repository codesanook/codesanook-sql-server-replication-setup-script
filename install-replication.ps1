#include replication library 
. "$PSScriptRoot/replication.ps1"

#setup group 1 replication
$publisher = "DESKTOP-TEOD82V\PUBLISHER"
$distributor = "DESKTOP-TEOD82V\DISTRIBUTOR"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER"

New-Replication `
    -Publisher $publisher `
    -Distributor $distributor `
    -Subscriber $subscriber `
    -PublicationDB "ThingsToDo" `
    -ArticleTable "ToDoItems" `
    -ArticleStoredProc "InsertToDoItem"

Write-Host "Set up replication successfully"