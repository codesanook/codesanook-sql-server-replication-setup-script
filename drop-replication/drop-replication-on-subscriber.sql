--- on subscriber database

--5 Remove replication objects from the subscription database.
DECLARE @publisher AS sysname;
DECLARE @publication AS sysname;
DECLARE @publicationDB AS sysname;
DECLARE @subscriptionDB AS sysname

SET @publisher = '$(publisher)';
SET @publication = '$(publication)'; 
SET @publicationDB = '$(publicationDB)'; 
SET @subscriptionDB = '$(subscriptionDB)'


--Remove replication objects from a subscription database 
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-removedbreplication-transact-sql
EXEC sp_removedbreplication @subscriptionDB

EXEC sp_subscription_cleanup @publisher, @publicationDB, @publication 