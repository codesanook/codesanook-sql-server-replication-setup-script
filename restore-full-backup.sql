
RESTORE DATABASE [AdventureWorks2014] FROM DISK = 'C:\backup-db\AdventureWorks2014_20171208.BAK' 
WITH 
MOVE 'AdventureWorks2014_Data' TO 'C:\db\AdventureWorks2014.mdf', 
MOVE 'AdventureWorks2014_Log' TO  'C:\db\AdventureWorks2014_Log.ldf', 
RECOVERY, REPLACE, STATS = 10;