param(
    [Parameter(Mandatory = $true)] [SecureString] $Password
)

# Import Replication module 
Import-Module -Name .\Replication -Force

$username = "sa"
$database = "ThingsToDo"
$publisherInstance = "localhost, 1433"
$subscriberInstance = "localhost, 1435"

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
Invoke-Query -Instance $publisherInstance -Database $database -Query $command -Username $username -Password $Password
"New record inserted"

"Wait a bit to get replication process done"
Start-Sleep -Seconds 5

$command = "SELECT * FROM ToDoItems"
Invoke-Query -Instance $subscriberInstance -Database $database -Query $command -Username $username -Password $Password
