DECLARE @publication AS SYSNAME
DECLARE @tableArticle AS SYSNAME
DECLARE @schemaowner AS SYSNAME

SET @publication = '$(publication)'
SET @tableArticle = '$(tableArticle)'
SET @schemaOwner = 'dbo'

-- Manually set @schema_option to ensure that the Production schema is generated at the Subscriber
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addarticle-transact-sql
EXEC sp_addarticle 
	@publication = @publication, 
	@article = @tableArticle, 
	@source_object = @tableArticle,
	@source_owner = @schemaOwner, 
	@schema_option = 0x00000000080350DF,
	@vertical_partition = 'false', -- Indicates there is no vertical filtering and publishes all columns.
	@identityrangemanagementoption = 'manual', -- Prevent error when try to insert a new record
	@type = 'logbased',

    @ins_cmd = 'CALL sp_MSins_dbo$(tableArticle)',
    @del_cmd = 'CALL sp_MSdel_dbo$(tableArticle)',
    @upd_cmd = 'SCALL sp_MSupd_dbo$(tableArticle)',

    @destination_table = @tableArticle,
    @destination_owner = @schemaOwner,
    @creation_script = null,
	@pre_creation_cmd = 'drop'
GO