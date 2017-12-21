DECLARE @publication AS sysname;
DECLARE @articleTable AS sysname;
DECLARE @articleStoredProc AS sysname;
DECLARE @schemaowner AS sysname;

SET @publication = '$(publication)'; 
SET @articleTable = '$(articleTable)';
SET @articleStoredProc = '$(articleStoredProc)';
SET @schemaowner = 'dbo';

-- Manually set @schema_option to ensure that the Production schema 
-- is generated at the Subscriber (0x8000000).
--https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addarticle-transact-sql
EXEC sp_addarticle 
	@publication = @publication, 
	@article = @articleTable, 
	@source_object = @articleTable,
	@source_owner = @schemaowner, 
	@schema_option = 0x80030F3,
	@vertical_partition = N'false', 
	@identityrangemanagementoption = 'manual', --prevent error when try ton insert SQLr
	@type = N'logbased'

-- is generated at the Subscriber (0x8000000).
/*
EXEC sp_addarticle 
	@publication = @publication, 
	@article = @articleStoredProc,
	@source_object = @articleStoredProc,
	@source_owner = @schemaowner, 
	@schema_option = 0x8000001,
	@vertical_partition = N'false', 
	@type = N'proc schema only' --Procedure with schema only.
	*/