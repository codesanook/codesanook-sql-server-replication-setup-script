--- on distributor

--6 drop distributor 
DECLARE @publisher AS sysname;
SET @publisher = N'DESKTOP-TEOD82V\PUBLISHER';

-- Remove the registration of the local Publisher at the Distributor.
USE master
EXEC sp_dropdistpublisher @publisher;

DECLARE @distributionDB AS sysname;
SET @distributionDB = N'distribution';

-- Delete the distribution database.
EXEC sp_dropdistributiondb @distributionDB;

-- Remove the local server as a Distributor.
EXEC sp_dropdistributor;


--Sometime,we need to kill process that connect to distributor database    
--SELECT spid FROM sys.sysprocesses WHERE dbid = db_id('distribution')

/*
USE master
KILL 52
*/
