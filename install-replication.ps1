#include replication library 
. "$PSScriptRoot/Replication.ps1"
. "$PSScriptRoot/New-Database.ps1"

$arguments = @{
    Publisher = "DESKTOP-TEOD82V\PUBLISHER"
    Distributor =  "DESKTOP-TEOD82V\DISTRIBUTOR"
    Subscriber = "DESKTOP-TEOD82V\SUBSCRIBER"
    PublicationDB = "ThingsToDo"
    ArticleTable = "ToDoItems"
    ArticleStoredProc = "InsertToDoItem"
}

New-Replication @arguments 
"Set up replication successfully"