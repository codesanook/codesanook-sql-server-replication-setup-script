/*
sysname is a built in datatype limited to 128 Unicode characters that, IIRC, 
is used primarily to store object names when creating scripts. 
Its value cannot be NULL
It is basically the same as using nvarchar(128) NOT NULL
*/
-- Execute this script on distributor database

-- Install the Distributor and the distribution database.
DECLARE @distributor AS sysname;
DECLARE @distributionDB AS sysname;
DECLARE @password NVARCHAR(20) = N'12345';

SET @distributor = 'DESKTOP-TEOD82V\DISTRIBUTOR';
-- Specify the distribution database.
SET @distributionDB = N'distribution';
-- Specify the Publisher name.


-- create distributor with password.
USE master
EXEC sp_adddistributor @distributor = @distributor, @password = @password


-- Create a new distribution database using the defaults, including
-- using ad Windows Authentication.
USE master
EXEC sp_adddistributiondb @database = @distributionDB, 
    @security_mode = 1;
GO


-- Create a Publisher on distributor server in distribution database
DECLARE @distributionDB AS sysname;
DECLARE @publisher AS sysname;
-- Specify the distribution database.
SET @distributionDB = N'distribution';
-- Specify the Publisher name.
SET @publisher = 'DESKTOP-TEOD82V\PUBLISHER';

USE [distribution]
EXEC sp_adddistpublisher @publisher=@publisher, 
    @distribution_db=@distributionDB, 
    @security_mode = 1;
GO 
