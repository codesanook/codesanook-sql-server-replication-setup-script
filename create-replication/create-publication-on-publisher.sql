DECLARE @publicationDB AS sysname;
DECLARE @publication AS sysname;
DECLARE @jobLogin AS sysname;
DECLARE @jobPassword AS sysname;

SET @publicationDB = '$(publicationDB)'; 
SET @publication = '$(publication)'; 

-- Windows account used to run the Log Reader and Snapshot Agents.
SET @jobLogin = '$(jobLogin)'
SET @jobPassword = '$(jobPassword)' 

-- Enable transactional or snapshot replication on the publication database.
EXEC sp_replicationdboption 
	@dbname=@publicationDB, 
	@optname=N'publish',
	@value = N'true';

-- Execute sp_addlogreader_agent to create the agent job. 
EXEC sp_addlogreader_agent 
	@job_login = @jobLogin, 
	@job_password = @jobPassword,
	-- Explicitly specify the use of Windows Integrated Authentication (default) 
	-- when connecting to the Publisher.
	@publisher_security_mode = 1;

-- Create a new transactional publication with the required properties. 
EXEC sp_addpublication 
	@publication = @publication, 
	@status = N'active',
	@allow_push = N'true',
	@allow_pull = N'true',
	@independent_agent = N'true',
	@allow_initialize_from_backup = N'true'; --We will initialize replication from backup file
	--@immediate_sync = N'true';