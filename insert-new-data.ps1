#include replication library 
. "$PSScriptRoot/replication.ps1"

$publisher = "DESKTOP-TEOD82V\PUBLISHER"
$subscriber = "DESKTOP-TEOD82V\SUBSCRIBER"

$database = "ThingsToDo"
$sqlFilePath = "insert-new-data.sql"

$title = "Say XinChao"
$details = "Say XinChao to everyone"

$command = @"
    DECLARE @newId INT
    EXEC dbo.InsertToDoItem 
        @title = '$title', 
        @Details = '$details', 
        @NewId = @newId OUTPUT

    PRINT @newId
"@

Invoke-Query -Instance $publisher -Database $database -Query $command
"new data inserted"

"Wait a bit to get replication process done"
Start-Sleep -Seconds 15

$command = @"
    SELECT * FROM ToDoItems
"@

Invoke-Query -Instance $subscriber -Database $database -Query $command