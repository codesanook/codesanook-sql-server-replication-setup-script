DECLARE @backupDBName VARCHAR(50)
DECLARE @backupDBDirectory VARCHAR(256) -- path for backup files  
DECLARE @backupDBFilePath VARCHAR(512) -- path for backup files  
 
-- specify database backup directory
SET @backupDBName = '$(backupDBName)'
SET @backupDBDirectory = '$(backupDBDirectory)'
--SELECT @fileDate = --CONVERT(VARCHAR(20),GETDATE(),112) 

--Make sure this filePath is valid, folders already created 
SET @backupDBFilePath = @backupDBDirectory + @backupDBName + '.BAK'  

BACKUP DATABASE @backupDBName TO DISK = @backupDBFilePath  