USE msdb
GO

EXEC dbo.sp_update_job 
    @job_name = 'Distribution clean up: distribution', 
    @enabled = 1

EXEC dbo.sp_start_job @job_name = 'Distribution clean up: distribution'
GO


