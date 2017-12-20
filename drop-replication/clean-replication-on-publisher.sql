-- https://technet.microsoft.com/en-us/library/ms147921(v=sql.105).aspx
DECLARE @publicationDB AS sysname;
SET @publicationDB = '$(publicationDB)'; 

--(Optional) If this database has no other publications, execute sp_replicationdboption (Transact-SQL) 
--to disable publication of the current database using snapshot or transactional replication.
--Remove replication objects from the database.

--https://technet.microsoft.com/en-us/library/ms147833(v=sql.105).aspx
EXEC sp_replicationdboption @dbname = @publicationDB, @optname = N'publish', @value = N'false'; ---disable the given replication database option

-- Remove the registration of the local Publisher at the Distributor.
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-dropdistributor-transact-sql
--EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1
EXEC sp_dropdistributor