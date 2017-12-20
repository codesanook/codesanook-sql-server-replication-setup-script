--- on distributor
DECLARE @publisher AS sysname;
SET @publisher = '$(publisher)'

-- Remove the registration of Publisher at the Distributor.
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-dropdistpublisher-transact-sql
EXEC sp_dropdistpublisher @publisher = @publisher, @no_checks = 1, @ignore_distributor = 1