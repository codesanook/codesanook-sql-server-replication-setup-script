
USE AdventureWorks2014
go


DECLARE @publication    AS sysname;
DECLARE @table AS sysname;
DECLARE @schemaowner AS sysname;
SET @publication = N'TestPerson'; 
SET @table = N'Users';
SET @schemaowner = N'dbo';

-- Manually set @schema_option to ensure that the Production schema 
-- is generated at the Subscriber (0x8000000).
EXEC sp_addarticle 
	@publication = @publication, 
	@article = @table, 
	@source_object = @table,
	@source_owner = @schemaowner, 
	@schema_option = 0x80030F3,
	@vertical_partition = N'false', 
	@type = N'logbased'

