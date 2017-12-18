
EXEC dbo.sp_update_job @job_name = 'Distribution clean up: distribution', @enabled = 0;
EXEC dbo.sp_stop_job @job_name = 'Distribution clean up: distribution'