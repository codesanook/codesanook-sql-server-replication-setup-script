DECLARE @jobName AS sysname;
SET @jobName = 'Distribution clean up: distribution'

--disable job to auto restart
EXEC dbo.sp_update_job @job_name = @jobName, @enabled = 0;

--stop job if it is running 
If EXISTS(
    SELECT sj.name
    FROM dbo.sysjobactivity AS sja
    INNER JOIN dbo.sysjobs AS sj ON sja.job_id = sj.job_id
    WHERE sja.start_execution_date IS NOT NULL
    AND sja.stop_execution_date IS NULL
    AND sj.name = @jobName 
) 
BEGIN
    PRINT 'stopping job'
    EXEC dbo.sp_stop_job @job_name = @jobName 
END