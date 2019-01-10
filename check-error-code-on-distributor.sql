   use distribution
   go
    
	exec sp_browsereplcmds
	@xact_seqno_start = '0x0000000000000000000000000000', 
	@xact_seqno_end =   '0x000000FF00000000000000000000'
