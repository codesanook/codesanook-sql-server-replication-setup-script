# My basic replication presentation (Google slide)
[link to the presentation](https://docs.google.com/presentation/d/1WVNzJEmeNGpoRpzuFr0Y-C-_od4R3oDrrMkifdlVNVM/edit?usp=sharing)

# Requirement

At least SQL Server Developer edition 2014
Now, Microsoft SQL Server Developer is free now, you can down load from

For 2014:
https://my.visualstudio.com/Downloads?q=SQL%20Server%202014%20Developer

For 2016:
https://my.visualstudio.com/Downloads?q=SQL%20Server%202016%20Developer

If you have installed SQL computer, you can check with the following query.

```
SELECT @@VERSION AS SqlServerVersion
```


You need three SQL server instances for:
* Publisher
* Subscriber
* Distributor

## To setup replication with create a new database
* Launch a new PowerShell terminal
* CD to the root of the project
* Open Install-Replication.ps1 and change all variables to match your need.
* Run the Install-Replication.ps1 script
```
. \Install-Replication.ps1
```
* After setup is successfully, you will have a new database with replication setup


## To remove replication
* Run the Install-Replication.ps1 script

## Testing a replication
* Run New-ToDoItem.ps1
