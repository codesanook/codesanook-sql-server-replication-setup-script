USE master
GO

-- crete a full backup SQL server

DECLARE @name VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name
 
-- specify database backup directory
SET @path = 'C:\backup-db\'  
SET @name = 'AdventureWorks2014'
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

--Make sure this filePath is valid, folders already created 
SET @fileName = @path + @name + '_log3_' + @fileDate + '.TRN'  

BACKUP LOG @name 
	TO DISK = @fileName  
GO