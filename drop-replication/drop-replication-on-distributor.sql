DECLARE @publisher AS sysname;
SET @publisher = '$(publisher)'

-- Remove the registration of Publisher at the Distributor.
-- At the Distributor, execute sp_dropdistpublisher. This stored procedure should be run once for each Publisher registered at the Distributor.
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-dropdistpublisher-transact-sql
EXEC sp_dropdistpublisher @publisher = @publisher

-- Drop the distribution database.
DECLARE @distributionDB AS sysname
SET @distributionDB = '$(distributionDB)'
EXEC sp_dropdistributiondb @distributionDB

-- Remove the local server as a Distributor.
EXEC sp_dropdistributor --@no_checks = 1