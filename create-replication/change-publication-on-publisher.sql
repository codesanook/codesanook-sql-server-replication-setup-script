DECLARE @publication AS sysname;
SET @publication = '$(publication)'; 

exec sp_changepublication
@publication = @publication, 
@property = N'allow_initialize_from_backup',
@value = N'true'--We will initialize replication from backup file