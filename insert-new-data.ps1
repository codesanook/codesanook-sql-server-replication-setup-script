#include replication library 
. "$PSScriptRoot/replication.ps1"

$publisher = "DESKTOP-TEOD82V\PUBLISHER"
$database = "AdventureWorks2014"
$sqlFilePath = "insert-new-data.sql"

for ($i = 0; $i -lt 500 ; $i++) {
    $firstName = "Xin Chaooo"
    $variables = @(
        "firstName=$firstName"
    )

    Invoke-Query -Instance $publisher -Database $database -SqlFilePath $sqlFilePath -Variables $variables 
    "new data inserted"
    Start-Sleep -Seconds 5 
}