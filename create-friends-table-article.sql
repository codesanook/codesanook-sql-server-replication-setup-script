USE MyStartup
GO

DECLARE @publication AS sysname;
DECLARE @articleTable AS sysname;
DECLARE @schemaowner AS sysname;

SET @publication = 'MyStartupPublication'; 
SET @articleTable = 'Friends';
SET @schemaowner = 'dbo';

-- Manually set @schema_option to ensure that the Production schema 
-- is generated at the Subscriber (0x8000000).
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addarticle-transact-sql
EXEC sp_addarticle 
	@publication = @publication, 
	@article = @articleTable, 
	@source_object = @articleTable,
	@source_owner = @schemaowner, 
	@schema_option = 0x00000000080350DF,
	@vertical_partition = N'false', -- indicates there is no vertical filtering and publishes all columns.
	@identityrangemanagementoption = 'manual', --prevent error when try ton insert SQLr
	@type = N'logbased',

    @ins_cmd = 'CALL sp_MSins_dboFriends',
    @del_cmd = 'CALL sp_MSdel_dboFriends',
    @upd_cmd = 'SCALL sp_MSupd_dboFriends',
    @destination_table = @articleTable , --name of destination table or stored proc
    @destination_owner = @schemaowner,
    @creation_script = null,
	@pre_creation_cmd = N'drop';

	GO
