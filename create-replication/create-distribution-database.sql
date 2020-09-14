-- Create a distrition database.
-- Execute this script at a distributor on a master database.
USE master
GO

DECLARE @distributionDB AS NVARCHAR(20)
DECLARE @username NVARCHAR(20)
DECLARE @password NVARCHAR(20)

SET @distributionDB = '$(distributionDB)'
SET @username = '$(username)'
SET @password = '$(password)'

EXEC sp_adddistributiondb 
    @database = @distributionDB, 
    @security_mode = 0, -- To use SQL Server authentication
    @login = @username,
    @password = @password
GO
