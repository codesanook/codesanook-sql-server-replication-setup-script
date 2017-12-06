
---on publisher from 

-- 1 remove subscription from publisher
DECLARE @publication AS sysname;
DECLARE @subscriber AS sysname;

SET @publication = N'TestPerson';
SET @subscriber = N'DESKTOP-TEOD82V\SUBSCRIBER';

USE [AdventureWorks2014]
EXEC sp_dropsubscription 
  @publication = @publication, 
  @article = N'all',
  @subscriber = @subscriber;
GO


--2 remove publication on publisher
DECLARE @publicationDB AS sysname;
DECLARE @publication AS sysname;
SET @publicationDB = N'AdventureWorks2014'; 
SET @publication = N'TestPerson'; 

-- Remove a transactional publication.
USE [AdventureWorks2014]
EXEC sp_droppublication @publication = @publication;

--Remove replication objects from the database.
USE [master]
EXEC sp_replicationdboption @dbname = @publicationDB, @optname = N'publish', @value = N'false'; ---disable the given replication database option
GO



--3 Remove replication objects from the publication database
DECLARE @publicationDB AS sysname
SET @publicationDB = N'AdventureWorks2014'

--Remove replication objects from a publisher database
--This stored procedure is executed at the Publisher on the publication database or at the Subscriber on the subscription database. 
--The procedure removes all replication objects from the database in which it is executed, but it does not remove objects from other databases, 
--such as the distribution database.- Disable the publication database.
USE master
EXEC sp_removedbreplication @publicationDB
GO

-- Remove the registration of the local Publisher at the Distributor.
USE master
EXEC sp_dropdistpublisher @publisher;

--verify if it optional
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-dropdistributor-transact-sql
-- Delete the distribution database.
EXEC sp_dropdistributiondb @distributionDB;

--4 Remove the local server as a Distributor.
EXEC sp_dropdistributor;
GO


