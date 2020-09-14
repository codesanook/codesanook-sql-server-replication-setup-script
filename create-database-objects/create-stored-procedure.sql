IF OBJECT_ID('InsertToDoItem', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertToDoItem 
END

EXEC ('
    CREATE PROCEDURE InsertToDoItem
        @Title NVARCHAR(256),
        @Details NVARCHAR(124),
        @NewId INT = NULL OUTPUT
    AS
    BEGIN
        INSERT INTO ToDoItems
            (Title, Details)
        VALUES
            (@Title, @Details)

        SET @NewId = SCOPE_IDENTITY();
    END
')



