USE master
GO

DECLARE @databaseName SYSNAME
SET @databaseName = '$(publicationDB)'

-- Drop if exist
IF DB_ID(@databaseName) IS NOT NULL
BEGIN
	EXEC('DROP DATABASE ' + @databaseName )
END

-- Restore full backup to a default location
RESTORE DATABASE @databaseName 
FROM DISK = '$(backupPath)'
WITH 
	RECOVERY, 
	REPLACE
GO

