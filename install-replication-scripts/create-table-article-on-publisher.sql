DECLARE @schemaowner AS SYSNAME
SET @schemaOwner = 'dbo'

-- Manually set @schema_option to ensure that the Production schema is generated at the Subscriber
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addarticle-transact-sql
/*
@schema_option is a bitmask of the schema generation option for the given article.
schema_option is binary(8), binary with 8 byte length or 16 digits hexadecimal.

It is created from | (Bitwise OR) product of one or more of the list of hexademial that can be find here.
https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addarticle-transact-sql

Our script set @schema_option to 0x00000000080350DF and 0x0000000008000001.

For 0x00000000080350DF value, it is from a Bitwise OR operation on these values:
0x01      - Generates the object creation script (CREATE TABLE, CREATE PROCEDURE, and so on). This value is the default for stored procedure article.
0x02      - Generates the stored procedures that propagate changes for the article, if defined.
0x04      - Identity columns are scripted using the IDENTITY property.
0x08      - Replicate timestamp columns. If not set, timestamp columns are replicated as binary.
0x10      - Generates a corresponding clustered index. Even if this option is not set, indexes related to primary keys and unique constraints are generated if they are already defined on a published table.
0x40      - Generates corresponding nonclustered indexes. Even if this option is not set, indexes related to primary keys and unique constraints are generated if they are already defined on a published table.
0x80      - Replicates primary key constraints. Any indexes related to the constraint are also replicated, even if options 0x10 and 0x40 are not enabled.
0x1000    - Replicates column-level collation
0x4000    - Replicates UNIQUE constraints. Any indexes related to the constraint are also replicated, even if options 0x10 and 0x40 are not enabled
0x10000   - Replicates CHECK constraints as NOT FOR REPLICATION so that the constraints are not enforced during synchronization
0x20000   - Replicates FOREIGN KEY constraints as NOT FOR REPLICATION so that the constraints are not enforced during synchronization
0x8000000 - Creates any schemas not already present on the subscriber

We can do calculation like this.
$option =
	0x01     -bor
	0x02     -bor
	0x04     -bor
	0x08     -bor
	0x10     -bor
	0x40     -bor
	0x80     -bor
	0x1000   -bor
	0x4000   -bor
	0x10000  -bor
	0x20000  -bor
	0x8000000
$option.ToString("X") 
It return 80350DF, we can add leading 0 to make it 16 digits hexadecimal value

To check if the number has a spicific option or not, we do it by using Bitwise AND between an option value and the specific option we are interested in.
For example, our option value is 0x00000000080350DF and we want to check if it has 0x8000000 option or not.
We can do this calculation:
$option = 0x00000000080350DF -band 0x8000000
$option.ToString("X") 
It returns 8000000 which means this option has 0x8000000 (Create any schemas not already present on the subscriber)

For 0x0000000008000001 value, it is from bitwise OR operation on these value:
0x01      - Generates the object creation script (CREATE TABLE, CREATE PROCEDURE, and so on). This value is the default for stored procedure articles.
0x8000000 - Creates any schemas not already present on the subscriber
*/

EXEC sp_addarticle 
	@publication = '$(publication)',
	@article = '$(tableArticle)', 
	@source_object = '$(tableArticle)',
	@source_owner = @schemaOwner, 
	@schema_option = 0x00000000080350DF, -- TODO add definition of this number
	@vertical_partition = 'false', -- Indicates there is no vertical filtering and publish all columns.
	@identityrangemanagementoption = 'manual', -- Prevent error when try to insert a new record
	@type = 'logbased',

    @ins_cmd = 'CALL sp_MSins_dbo$(tableArticle)',
    @del_cmd = 'CALL sp_MSdel_dbo$(tableArticle)',
    @upd_cmd = 'SCALL sp_MSupd_dbo$(tableArticle)',

    @destination_table = '$(tableArticle)',
    @destination_owner = @schemaOwner,
    @creation_script = null,
	@pre_creation_cmd = 'drop'
GO
