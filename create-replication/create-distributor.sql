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
DECLARE @distributorPassword NVARCHAR(20) 

SET @distributor = '$(distributor)';
SET @distributionDB = '$(distributionDB)';
SET @distributorPassword = '$(distributorPassword)';

-- create distributor with password.
EXEC sp_adddistributor @distributor = @distributor, @password = @distributorPassword

-- Create a new distribution database using the defaults, including
-- using ad Windows Authentication.
EXEC sp_adddistributiondb @database = @distributionDB, 
    @security_mode = 1;

