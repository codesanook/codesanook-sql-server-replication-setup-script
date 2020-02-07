param(
    [Parameter(Mandatory = $true)] [SecureString] $password
)
# Import Replication module 
Import-Module -Name .\Replication -Force

$publisher = "publisher"
$masterDatase = "master"
$applicationDatabase = "ThingsToDo"

$username = "sa" 
#$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

Stop-DatabaseProcess `
    -Instance $publisher `
    -Database $applicationDatabase `
    -Username $username `
    -Password $password

$createDatabaseScript = "./create-database-objects/create-database.sql" 
Invoke-Query `
    -Instance $publisher `
    -Database $masterDatase `
    -SqlFilePath $createDatabaseScript `
    -Username $username `
    -Password $password
"Database $applicationDatabase created"
    
$createTableScript = "./create-database-objects/create-table.sql" 
Invoke-Query `
    -Instance $publisher `
    -Database $applicationDatabase `
    -SqlFilePath $createTableScript `
    -Username $username `
    -Password $password
"Table created on database $applicationDatabase"

$createStoredProcedureScript = "./create-database-objects/create-stored-procedure.sql" 
Invoke-Query `
    -Instance $publisher `
    -Database $applicationDatabase `
    -SqlFilePath $createStoredProcedureScript `
    -Username $username `
    -Password $password
"Stored proc created on database $applicationDatabase"
return

$arguments = @{
    Publisher         = $publisher
    Distributor       = "distributor"
    Subscriber        = "subscriber"
    PublicationDB     = "ThingsToDo"
    ArticleTable      = "ToDoItems"
    ArticleStoredProc = "InsertToDoItem"
}

New-Replication @arguments 
"Set up replication successfully"
