--- on subscriber database

--5 Remove replication objects from the subscription database.
DECLARE @subscriptionDB AS sysname
SET @subscriptionDB = N'AdWorksRepl'

--Remove replication objects from a subscription database 
USE master
EXEC sp_removedbreplication @subscriptionDB
GO
