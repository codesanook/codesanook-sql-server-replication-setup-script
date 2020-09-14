-- Configure a publisher to use a distribution database.
-- Execute this script at a distrbutor on distribution database
USE master
GO

DECLARE @publisher AS sysname
DECLARE @distributionDB AS sysname
DECLARE @username NVARCHAR(20)
DECLARE @password NVARCHAR(20)

SET @distributionDB = '$(distributionDB)' 
SET @publisher = '$(publisher)'

SET @username = '$(username)'
SET @password = '$(password)'

EXEC sp_adddistpublisher 
    @publisher=@publisher, 
    @distribution_db=@distributionDB, 
    @security_mode = 0,
    @login = @username,
    @password = @password
GO 