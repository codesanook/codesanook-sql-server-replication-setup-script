--- on distributor

--6 drop distributor 
DECLARE @publisher AS sysname;
SET @publisher = N'DESKTOP-TEOD82V\PUBLISHER';

-- Remove the registration of Publisher at the Distributor.
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-dropdistpublisher-transact-sql
EXEC sp_dropdistpublisher @publisher = @publisher, @no_checks = 1, @ignore_distributor = 1
--EXEC sp_dropdistpublisher @publisher;

--Delete the distribution database.
DECLARE @distributionDB AS sysname;
SET @distributionDB = N'distribution';
EXEC sp_dropdistributiondb @distributionDB;

-- Remove the local server as a Distributor.
-- remove the Distributor designation from the server.
EXEC sp_dropdistributor;

--Sometime,we need to kill process that connect to distributor database    
--SELECT spid FROM sys.sysprocesses WHERE dbid = db_id('distribution')

/*
USE master
KILL 64
*/
