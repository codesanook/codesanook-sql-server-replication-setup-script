USE distribution
GO

EXEC sp_browsereplcmds
	@xact_seqno_start = '0x0000000000000000000000000000',
	@xact_seqno_end =   '0x000000FF00000000000000000000',
	@publisher_database_id = 1, -- Get FROM SELECT * FROM MSpublisher_databases
GO
