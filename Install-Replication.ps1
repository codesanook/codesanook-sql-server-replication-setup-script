param(
    [Parameter(Mandatory = $true)] [SecureString] $Password
)

# Import Replication module 
Import-Module -Name .\Replication -Force

# We specified the a container host name and we don't need to worry about port of SQL server instance port
$publisher = "publisher"
$distributor = "distributor"
$subscriber = "subscriber"

$username = "sa" 
$masterDatase = "master"
$applicationDatabase = "ThingsToDo"
$articleTable = "ToDoItems"
$articleStoredProc = "InsertToDoItem"

Stop-DatabaseProcess `
    -Instance $publisher `
    -Database $applicationDatabase `
    -Username $username `
    -Password $Password

$createDatabaseScript = "./create-database-objects/create-database.sql" 
Invoke-Query `
    -Instance $publisher `
    -Database $masterDatase `
    -SqlFilePath $createDatabaseScript `
    -Username $username `
    -Password $Password
"Database $applicationDatabase created"
    
$createTableScript = "./create-database-objects/create-table.sql" 
Invoke-Query `
    -Instance $publisher `
    -Database $applicationDatabase `
    -SqlFilePath $createTableScript `
    -Username $username `
    -Password $Password
"Table created on a database $applicationDatabase"

$createStoredProcedureScript = "./create-database-objects/create-stored-procedure.sql" 
Invoke-Query `
    -Instance $publisher `
    -Database $applicationDatabase `
    -SqlFilePath $createStoredProcedureScript `
    -Username $username `
    -Password $Password
"Stored proc created on a database $applicationDatabase"

$arguments = @{
    Publisher         = $publisher
    Distributor       = $distributor
    Subscriber        = $subscriber
    PublicationDB     = $applicationDatabase
    ArticleTable      = $articleTable
    ArticleStoredProc = $articleStoredProc
    Username          = $username
    Password          = $Password 
}

Install-Replication @arguments 
"Set up replication successfully"
