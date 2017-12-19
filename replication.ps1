#https://docs.microsoft.com/en-us/sql/powershell/invoke-sqlcmd-cmdlet
function Invoke-Query($Instance, $Database, $SqlFilePath, $Variables) {
    Push-Location
    Invoke-Sqlcmd -ServerInstance $Instance -Database $Database -InputFile $SqlFilePath -Variable $Variables -ErrorAction Stop
    Pop-Location
}