IF db_id('AdventureWorks2014') IS NOT NULL
BEGIN
	DROP DATABASE AdventureWorks2014
END

--restore full backup
RESTORE DATABASE [AdventureWorks2014] FROM DISK = 'C:\backup-db\AdventureWorks2014_full.BAK' 
WITH 
MOVE 'AdventureWorks2014_Data' TO 'C:\db\AdventureWorks2014.mdf', 
MOVE 'AdventureWorks2014_Log' TO  'C:\db\AdventureWorks2014_Log.ldf', 
RECOVERY, REPLACE, STATS = 10;


