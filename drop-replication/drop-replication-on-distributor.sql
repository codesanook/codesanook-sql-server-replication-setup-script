--- on distributor
DECLARE @publisher AS sysname;
SET @publisher = '$(publisher)'
-- Remove the registration of Publisher at the Distributor.
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-dropdistpublisher-transact-sql
--EXEC sp_dropdistpublisher @publisher = @publisher, @no_checks = 1, @ignore_distributor = 1

-- At the Distributor, execute sp_dropdistpublisher. This stored procedure should be run once for each Publisher registered at the Distributor.
--EXEC sp_dropdistpublisher @publisher = @publisher, @no_checks = 1, @ignore_distributor = 1
EXEC sp_dropdistpublisher @publisher = @publisher

--Delete the distribution database.
DECLARE @distributionDB AS sysname;
SET @distributionDB = '$(distributionDB)';
EXEC sp_dropdistributiondb @distributionDB;

-- Remove the local server as a Distributor.
-- remove the Distributor designation from the server.
--EXEC sp_dropdistributor @no_checks = 1
EXEC sp_dropdistributor @no_checks = 1
--Sometime,we need to kill process that connect to distributor database    
--SELECT spid FROM sys.sysprocesses WHERE dbid = db_id('distribution')
/*
USE master
KILL 64
*/
