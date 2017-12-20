--https://technet.microsoft.com/en-us/library/ms152757(v=sql.105).aspx

-- 1 remove subscription from publisher
DECLARE @publication AS sysname;
DECLARE @subscriber AS sysname;
DECLARE @publicationDB AS sysname;

SET @publication = '$(publication)';
SET @subscriber = '$(subscriber)';
SET @publicationDB = '$(publicationDB)'; 

-- https://technet.microsoft.com/en-us/library/ms146944(v=sql.105).aspx
EXEC sp_dropsubscription 
  @publication = @publication, 
  @subscriber = @subscriber,
  @article = N'all';

--2 remove publication on publisher
-- Remove a transactional publication.
EXEC sp_droppublication @publication = @publication;

--3 Remove replication objects from the publication database
--Remove replication objects from a publisher database
--This stored procedure is executed at the Publisher on the publication database or at the Subscriber on the subscription database. 
--The procedure removes all replication objects from the database in which it is executed, but it does not remove objects from other databases, 
--such as the distribution database.- Disable the publication database.
EXEC sp_removedbreplication @publicationDB