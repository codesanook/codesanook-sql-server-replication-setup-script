USE master
GO

-- Use WITH FORMAT to overwrite any existing backups and create a new one.
-- Backup to a default location /var/opt/mssql/backup/
BACKUP DATABASE $(publicationDB)
TO DISK = '$(backupPath)'
WITH FORMAT 
GO