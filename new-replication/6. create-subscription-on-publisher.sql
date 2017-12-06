USE AdventureWorks2014
GO

DECLARE @publication AS sysname;
DECLARE @subscriber AS sysname;
DECLARE @subscriptionDB AS sysname;
SET @publication = N'TestPerson';
SET @subscriber = 'DESKTOP-TEOD82V\SUBSCRIBER';
SET @subscriptionDB = N'AdventureWorks2014Repl';

--Add a push subscription to a transactional publication.
USE [AdventureWorks2014]
EXEC sp_addsubscription 
  @publication = @publication, 
  @subscriber = @subscriber, 
  @destination_db = @subscriptionDB, 
  @subscription_type = N'push';

--Add an distributor agent job to synchronize the push subscription.
EXEC sp_addpushsubscription_agent 
  @publication = @publication, 
  @subscriber = @subscriber, 
  @subscriber_db = @subscriptionDB, 
  @job_login = 'DESKTOP-TEOD82V\aaron', 
  @job_password = '12345';
GO