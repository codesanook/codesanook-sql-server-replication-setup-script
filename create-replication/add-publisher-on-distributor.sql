-- Create a Publisher on distributor server in distribution database
DECLARE @distributionDB AS sysname;
DECLARE @publisher AS sysname;

-- Specify the distribution database.
SET @distributionDB = '$(distributionDB)' 
-- Specify the Publisher name.
SET @publisher = '$(publisher)'

EXEC sp_adddistpublisher @publisher=@publisher, 
    @distribution_db=@distributionDB, 
    @security_mode = 1;
GO 