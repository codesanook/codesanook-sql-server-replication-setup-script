--- on subscriber database

--5 Remove replication objects from the subscription database.
DECLARE @subscriptionDB AS sysname
DECLARE @publicationDB AS sysname;
DECLARE @publication AS sysname;
DECLARE @publisher AS sysname;

SET @subscriptionDB = N'AdventureWorks2014'
SET @publisher = N'DESKTOP-TEOD82V\PUBLISHER';
SET @publicationDB = N'AdventureWorks2014'; 
SET @publication = N'TestPerson'; 

USE master

EXEC sp_subscription_cleanup @publisher, @publicationDB, @publication 

--Remove replication objects from a subscription database 
EXEC sp_removedbreplication @subscriptionDB
GO
