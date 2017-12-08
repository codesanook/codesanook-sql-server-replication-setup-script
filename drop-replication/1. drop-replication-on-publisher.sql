-- on publisher 

-- 1 remove subscription from publisher
DECLARE @publication AS sysname;
DECLARE @subscriber AS sysname;

SET @publication = N'TestPerson';
SET @subscriber = N'DESKTOP-TEOD82V\SUBSCRIBER';

USE [AdventureWorks2014]
EXEC sp_dropsubscription 
  @publication = @publication, 
  @subscriber = @subscriber,
  @article = N'all';
GO

--2 remove publication on publisher
DECLARE @publicationDB AS sysname;
DECLARE @publication AS sysname;

SET @publicationDB = N'AdventureWorks2014'; 
SET @publication = N'TestPerson'; 


-- Remove a transactional publication.
USE [AdventureWorks2014]
EXEC sp_droppublication @publication = @publication;
GO


--3 Remove replication objects from the publication database
DECLARE @publicationDB AS sysname
SET @publicationDB = N'AdventureWorks2014'
DECLARE @publisher AS sysname;
SET @publisher = N'DESKTOP-TEOD82V\PUBLISHER';

--Remove replication objects from a publisher database
--This stored procedure is executed at the Publisher on the publication database or at the Subscriber on the subscription database. 
--The procedure removes all replication objects from the database in which it is executed, but it does not remove objects from other databases, 
--such as the distribution database.- Disable the publication database.
USE master
EXEC sp_removedbreplication @publicationDB


---(Optional) If this database has no other publications, execute sp_replicationdboption (Transact-SQL) to disable publication of the current database using snapshot or transactional replication.
---- Remove replication objects from the database.

EXEC sp_replicationdboption @dbname = @publicationDB, @optname = N'publish', @value = N'false'; ---disable the given replication database option


--If the Publisher uses a remote Distributor, , execute sp_dropdistributor.
EXEC sp_dropdistributor;


--This stored procedure should be run once for each Publisher registered at the Distributor.
EXEC sp_dropdistpublisher @publisher;

GO

-- REF 
--https://technet.microsoft.com/en-us/library/ms147833(v=sql.105).aspx
