--drop if exist
IF db_id('$(backupDBName)') IS NOT NULL
BEGIN
	DROP DATABASE [$(backupDBName)] 
END

--restore full backup
RESTORE DATABASE [$(backupDBName)] 
	FROM DISK = '$(backupDBDirectory)$(backupDBName).BAK' 

WITH 
	MOVE '$(backupDBName)_Data' TO '$(restoreDBDirectory)$(backupDBName).mdf', 
	MOVE '$(backupDBName)_Log'  TO '$(restoreDBDirectory)$(backupDBName)_Log.ldf', 
	RECOVERY, REPLACE, STATS = 10;


