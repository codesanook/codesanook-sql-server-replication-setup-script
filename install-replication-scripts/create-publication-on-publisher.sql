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
	@allow_initialize_from_backup = 'false', 
	@immediate_sync = 'true' -- Avoid missing transactions while subscribers are being brought online.
