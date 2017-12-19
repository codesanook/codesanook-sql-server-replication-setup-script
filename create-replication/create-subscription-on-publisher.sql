DECLARE @publication AS sysname;
DECLARE @subscriber AS sysname;
DECLARE @subscriptionDB AS sysname;

SET @publication = '$(publication)';
SET @subscriber = '$(subscriber)';
SET @subscriptionDB = '$(subscriptionDB)';

--Add a push subscription to a transactional publication.
EXEC sp_addsubscription 
  @publication = @publication, 
  @subscriber = @subscriber, 
  @destination_db = @subscriptionDB, 
  @subscription_type = N'push',
  @sync_type = N'initialize with backup',	
  @backupdevicetype='Disk', 
  @backupdevicename = '$(backupDBDirectory)$(backupDBName).BAK';

--Add an distributor agent job to synchronize the push subscription.
EXEC sp_addpushsubscription_agent 
  @publication = @publication, 
  @subscriber = @subscriber, 
  @subscriber_db = @subscriptionDB, 
  @job_login = '$(jobLogin)', 
  @job_password = '$(jobPassword)'

--TODO initialize from Backup
-- https://justsql.wordpress.com/2012/10/25/sql-server-replication-initialize-from-backup/
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addsubscription-transact-sql