DECLARE @publication AS sysname;
DECLARE @articleTable AS sysname;
DECLARE @schemaowner AS sysname;

SET @publication = '$(publication)'; 
SET @articleTable = '$(articleTable)';
SET @schemaowner = 'dbo';

-- Manually set @schema_option to ensure that the Production schema 
-- is generated at the Subscriber (0x8000000).
EXEC sp_addarticle 
	@publication = @publication, 
	@article = @articleTable, 
	@source_object = @articleTable,
	@source_owner = @schemaowner, 
	@schema_option = 0x80030F3,
	@vertical_partition = N'false', 
	@identityrangemanagementoption = 'manual', --prevent error when try ton insert SQLr
	@type = N'logbased'