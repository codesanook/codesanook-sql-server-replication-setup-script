DECLARE @publication AS sysname;
DECLARE @articleStoredProc AS sysname;
DECLARE @schemaowner AS sysname;

SET @publication = '$(publication)'; 
SET @articleStoredProc = '$(articleStoredProc)';
SET @schemaowner = 'dbo';

-- Manually set @schema_option to ensure that the Production schema 
-- is generated at the Subscriber (0x8000000).
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addarticle-transact-sql
-- is generated at the Subscriber (0x8000000).
EXEC sp_addarticle 
	@publication = @publication, 
	@article = @articleStoredProc,
	@source_object = @articleStoredProc,
	@source_owner = @schemaowner, 
	@schema_option = 0x0000000008000001,
	@type = N'proc schema only', --Procedure with schema only.
    @destination_table = @articleStoredProc , --name of destination store proc 
    @destination_owner = @schemaowner,
    @creation_script = null,
	@pre_creation_cmd = N'drop';