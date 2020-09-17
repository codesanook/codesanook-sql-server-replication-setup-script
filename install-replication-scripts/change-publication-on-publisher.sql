EXEC sp_changepublication
    @publication = '$(publication)', 
    @property = 'allow_initialize_from_backup',
    @value = 'true' -- We will initialize replication from a backup file.