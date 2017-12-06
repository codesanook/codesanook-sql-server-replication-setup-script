use master

if db_id('AdventureWorks2014Repl') is not null
begin
	drop database AdventureWorks2014Repl
end

create database AdventureWorks2014Repl
go

