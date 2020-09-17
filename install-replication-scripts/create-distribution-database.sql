-- Create a distrition database.
-- Execute this script at a distributor on a master database.
USE master
GO

EXEC sp_adddistributiondb 
    @database = '$(distributionDB)', 
    @security_mode = 0, -- Use SQL Server authentication login
    -- login and password used when connecting to a distributor to create the distribution database
    @login = '$(username)', 
    @password = '$(password)'
GO
