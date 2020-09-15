DECLARE @publication AS SYSNAME
DECLARE @storedProcArticle AS SYSNAME
DECLARE @schemaowner AS SYSNAME

SET @publication = '$(publication)'
SET @storedProcArticle = '$(storedProcArticle)'
SET @schemaowner = 'dbo'

-- Manually set @schema_option to ensure that the Production schema is generated at the Subscriber
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addarticle-transact-sql
EXEC sp_addarticle 
	@publication = @publication, 
	@article = @storedProcArticle,
	@source_object = @storedProcArticle,
	@source_owner = @schemaowner, 
	@schema_option = 0x0000000008000001,
	@type = 'proc schema only', -- Procedure with schema only.
    @destination_table = @storedProcArticle, -- Name of destination table or stored proc 
    @destination_owner = @schemaowner,
    @creation_script = null,
	@pre_creation_cmd = 'drop'