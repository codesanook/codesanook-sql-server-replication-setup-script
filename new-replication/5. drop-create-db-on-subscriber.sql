use master

if db_id('AdventureWorks2014') is not null
begin
	drop database AdventureWorks2014
end

create database AdventureWorks2014
go


-- TODO restore database here