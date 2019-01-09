DECLARE @newId INT
EXEC dbo.InsertToDoItem 
    @title = 'Say XinChao', 
    @Details = 'Say XinChao to everyone', 
    @NewId = @newId OUTPUT

PRINT @newId