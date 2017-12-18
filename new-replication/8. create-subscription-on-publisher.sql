DECLARE @publication AS sysname;
DECLARE @subscriber AS sysname;
DECLARE @subscriptionDB AS sysname;
DECLARE @password NVARCHAR(255) = '12345';

SET @publication = N'TestPerson';
SET @subscriber = 'DESKTOP-TEOD82V\SUBSCRIBER';
SET @subscriptionDB = N'AdventureWorks2014';

--Add a push subscription to a transactional publication.
EXEC sp_addsubscription 
  @publication = @publication, 
  @subscriber = @subscriber, 
  @destination_db = @subscriptionDB, 
  @subscription_type = N'push',
  @sync_type = N'initialize with backup',	
  @backupdevicetype='Disk', 
  @backupdevicename = N'C:\backup-db\AdventureWorks2014_full.BAK';

--Add an distributor agent job to synchronize the push subscription.
EXEC sp_addpushsubscription_agent 
  @publication = @publication, 
  @subscriber = @subscriber, 
  @subscriber_db = @subscriptionDB, 
  @job_login = 'DESKTOP-TEOD82V\aaron', 
  @job_password = @password

--TODO initialize from Backup

-- https://justsql.wordpress.com/2012/10/25/sql-server-replication-initialize-from-backup/
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addsubscription-transact-sql