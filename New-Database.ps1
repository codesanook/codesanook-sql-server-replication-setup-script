$publisher = "DESKTOP-TEOD82V\PUBLISHER"
$masterDatase = "master"
$applicationDatabase = "ThingsToDo"

Clear-DatabaseProcess -Instance $publisher  -Database $applicationDatabase

$query = @"
    IF DB_ID('ThingsToDo') IS NOT NULL
    BEGIN
        Drop database $applicationDatabase
    END

    CREATE DATABASE ThingsToDo
    ALTER DATABASE ThingsToDo SET RECOVERY SIMPLE  
"@
Invoke-Query -Instance $publisher -Database $masterDatase -Query $query
"database $applicationDatabase created"

$createTableCommand = @"
	CREATE TABLE ToDoItems(
		Id INT NOT NULL IDENTITY(1, 1) ,
		Title NVARCHAR(256) NOT NULL ,
		Details NVARCHAR(1024) NULL,
		CONSTRAINT [PK_ToDoItems_Id] PRIMARY KEY CLUSTERED ([ID] ASC)
	)
"@
Invoke-Query -Instance $publisher -Database $applicationDatabase -Query $createTableCommand
"table created"

$createStoredProcCommand = @"
CREATE PROCEDURE InsertToDoItem
	@Title nvarchar(256),
	@Details nvarchar(124),
	@NewId int = null output
AS
BEGIN
	Insert into ToDoItems
		(Title, Details)
	Values
		(@Title, @Details)
	SET @NewId = SCOPE_IDENTITY();
END
"@
Invoke-Query -Instance $publisher -Database $applicationDatabase -Query $createStoredProcCommand
"stored proc created"