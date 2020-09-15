param(
    [Parameter(Mandatory = $true)] [SecureString] $Password
)

# Import Replication module 
Import-Module -Name .\Replication -Force

# We specified the a container host name and we don't need to worry about port of SQL server instance port
$publisher = "publisher"
$distributor = "distributor"
$subscriber = "subscriber"
$publisherInstance = "localhost,1433"

$publicationDB = "ThingsToDo"
$distributionDB = "distribution"
$subscriptionDB = "ThingsToDo"

$tableArticle = "ToDoItems"
$storedProcArticle = "InsertToDoItem"

$username = "sa" 

Stop-DatabaseProcess `
    -Instance $publisherInstance `
    -Database $publicationDB `
    -Username $username `
    -Password $Password

$createDatabaseScript = "./create-database-objects/create-database.sql" 
Invoke-Query `
    -Instance $publisherInstance `
    -Database 'master' `
    -SqlFilePath $createDatabaseScript `
    -Username $username `
    -Password $Password
"Database $publicationDB created"
    
$createTableScript = "./create-database-objects/create-table.sql" 
Invoke-Query `
    -Instance $publisherInstance `
    -Database $publicationDB `
    -SqlFilePath $createTableScript `
    -Username $username `
    -Password $Password
"Table created on a database $publicationDB"

$createStoredProcedureScript = "./create-database-objects/create-stored-procedure.sql" 
Invoke-Query `
    -Instance $publisherInstance `
    -Database $publicationDB `
    -SqlFilePath $createStoredProcedureScript `
    -Username $username `
    -Password $Password
"Stored proc created on a database $publicationDB"

# Pass arguments as hash table/dictionary
$arguments = @{
    Publisher         = $publisher
    Distributor       = $distributor
    Subscriber        = $subscriber

    PublicationDB     = $publicationDB
    DistributionDB    = $distributionDB
    SubscriptionDB    = $subscriptionDB

    TableArticle      = $tableArticle
    StoredProcArticle = $storedProcArticle
    Username          = $username
    Password          = $Password 
}

Install-Replication @arguments 
"Set up replication successfully"
