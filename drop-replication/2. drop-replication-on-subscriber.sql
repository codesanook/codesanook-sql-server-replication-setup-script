--- on subscriber database

--5 Remove replication objects from the subscription database.
DECLARE @subscriptionDB AS sysname
DECLARE @publicationDB AS sysname;
DECLARE @publication AS sysname;
DECLARE @publisher AS sysname;

SET @publisher = N'DESKTOP-TEOD82V\PUBLISHER';
SET @publicationDB = N'AdventureWorks2014'; 
SET @publication = N'TestPerson'; 
SET @subscriptionDB = N'AdventureWorks2014'

USE master
EXEC sp_subscription_cleanup @publisher, @publicationDB, @publication 

--Remove replication objects from a subscription database 
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-removedbreplication-transact-sql
EXEC sp_removedbreplication @subscriptionDB
GO
