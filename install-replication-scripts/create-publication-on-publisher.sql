-- Enable transactional replication on a publication database.
EXEC sp_replicationdboption
	@dbname = '$(publicationDB)',
	@optname = 'publish',
	@value = 'true'

-- Execute sp_addlogreader_agent to create an agent job. 
EXEC sp_addlogreader_agent
	-- Explicitly specify SQL Server authentication when connecting to a publisher.
	@publisher_security_mode = 0,
	@publisher_login = '$(username)',
    @publisher_password = '$(password)'

-- Create a new transactional publication with the required properties. 
EXEC sp_addpublication
	@publication = '$(publication)',
	@status = 'active',
	@allow_push = 'true',
	@independent_agent = 'true',
	-- Prevent errors that not creating stored proc for table aricles.
	-- We will set it to true after we create articles.
	-- Stored procedures don't generate on a subscription database when you configure a transactional replication in SQL Server
	-- https://support.microsoft.com/en-ca/help/2863979/fix-stored-procedures-don-t-generate-on-a-subscription-database-when-y
	@allow_initialize_from_backup = 'false', 
	@immediate_sync = 'true' -- Avoid missing transactions while subscribers are being brought online.
