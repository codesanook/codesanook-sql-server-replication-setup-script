-- Configure a publisher to use a distribution database.
-- Execute this script at a distrbutor on distribution database
USE master
GO

EXEC sp_adddistpublisher 
    @publisher = '$(publisher)', 
    @distribution_db = '$(distributionDB)', 
    -- Replication agents at the Distributor use SQL Server authentication to connect to the Publisher.
    @security_mode = 0,
    -- Used by replication agents to connect to the Publisher
    @login = '$(username)',
    @password = '$(password)'
GO 