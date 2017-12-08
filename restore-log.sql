USE master

go


RESTORE DATABASE [AdventureWorks2014] FROM DISK = 'C:\backup-db\AdventureWorks2014_20171208.BAK' 
WITH 
MOVE 'AdventureWorks2014_Data' TO 'C:\db\AdventureWorks2014.mdf', 
MOVE 'AdventureWorks2014_Log' TO  'C:\db\AdventureWorks2014_Log.ldf', 
NORECOVERY, REPLACE, STATS = 10;



RESTORE LOG [AdventureWorks2014]
 FROM  DISK = N'C:\backup-db\AdventureWorks2014_log_20171208.TRN' 
 WITH NORECOVERY
GO


RESTORE LOG [AdventureWorks2014]
 FROM  DISK = N'C:\backup-db\AdventureWorks2014_log2_20171208.TRN' 
 WITH NORECOVERY
GO


RESTORE LOG [AdventureWorks2014]
 FROM  DISK = N'C:\backup-db\AdventureWorks2014_log3_20171208.TRN' 
 WITH RECOVERY
GO