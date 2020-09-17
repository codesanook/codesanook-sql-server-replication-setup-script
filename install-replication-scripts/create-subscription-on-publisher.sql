DECLARE @publication AS SYSNAME
DECLARE @subscriber AS SYSNAME
DECLARE @subscriptionDB AS SYSNAME

SET @publication = '$(publication)'
SET @subscriber = '$(subscriber)'
SET @subscriptionDB = '$(subscriptionDB)'

-- Add a push subscription to a transactional publication.
EXEC sp_addsubscription 
  @publication = @publication, 
  @subscriber = @subscriber, 
  @destination_db = @subscriptionDB, 
  @subscription_type = 'push',
  @sync_type = 'initialize with backup',	
  @backupdevicetype = 'Disk',
  @update_mode = 'read only',
  @backupdevicename = '$(backupPath)'

--Add an distributor agent job to synchronize a push subscription.
EXEC sp_addpushsubscription_agent
  @publication = @publication, 
  @subscriber = @subscriber, 
  @subscriber_db = @subscriptionDB, 

  @subscriber_security_mode = 0,
  @subscriber_login = '$(username)',
  @subscriber_password = '$(password)'

-- TODO initialize from Backup
-- https://justsql.wordpress.com/2012/10/25/sql-server-replication-initialize-from-backup/
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addsubscription-transact-sql