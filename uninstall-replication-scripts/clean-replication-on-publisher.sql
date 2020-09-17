-- https://technet.microsoft.com/en-us/library/ms147921(v=sql.105).aspx
DECLARE @publicationDB AS sysname;
SET @publicationDB = '$(publicationDB)'; 

-- (Optional) If this database has no other publications, execute sp_replicationdboption (Transact-SQL) 
-- to disable publication of the current database using snapshot or transactional replication.
-- https://technet.microsoft.com/en-us/library/ms147833(v=sql.105).aspx
EXEC sp_replicationdboption @dbname = @publicationDB, @optname = N'publish', @value = N'false'; 

-- Remove the registration of the local Publisher at the Distributor.
-- If the Publisher uses a remote Distributor, execute sp_dropdistributor.
EXEC sp_dropdistributor