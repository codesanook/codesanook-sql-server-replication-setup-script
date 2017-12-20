--Delete the distribution database.
--DECLARE @distributionDB AS sysname;
--SET @distributionDB = '$(distributionDB)';
--EXEC sp_dropdistributiondb @distributionDB;

-- Remove the local server as a Distributor.
-- remove the Distributor designation from the server.
EXEC sp_dropdistributor @no_checks = 1

--Sometime,we need to kill process that connect to distributor database    
--SELECT spid FROM sys.sysprocesses WHERE dbid = db_id('distribution')
/*
USE master
KILL 64
*/
