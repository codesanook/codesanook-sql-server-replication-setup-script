/* 
    SYSNAME is a built-in datatype limited to 128 Unicode characters.
    It is used primarily to store object names when creating scripts. 
    It is basically the same as using nvarchar(128) NULL
*/
-- Configure a server as a distributor
-- Execute this script at a distributor on a master database.
USE master
GO

EXEC sp_adddistributor
    @distributor = '$(distributor)',
    -- @password is a password of the distributor_admin login that a publisher need to know to use a distributor.
    -- The same value for password must be specified when executing sp_adddistributor at both the publisher and distributor.
    -- Use sp_changedistributor_password to change the distributor password.
    @password = '$(distributorAdminPassword)'
GO
