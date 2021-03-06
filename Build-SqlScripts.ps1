#set script paths
$rootPath = "$PSScriptRoot\PowerConfluenceSqlRefresh\public\sql"
$dbName = "Confluence"

$objectsPath = "$rootPath\01-Create-Objects.sql"
$lookupsPath = "$rootPath\02-Create-Lookups.sql"

#remove the existing versions
Remove-Item $objectsPath
Remove-Item $lookupsPath

#create objects
$sqlComparePath = "C:\Program Files (x86)\Red Gate\SQL Compare 14\SQLCompare.exe"
& $sqlComparePath /server1:"localhost" /db1:$dbName /empty2 /sf:"$objectsPath"

#create lookup data
$sqlDataComparePath = "C:\Program Files (x86)\Red Gate\SQL Data Compare 14\SQLDataCompare.exe"
& $sqlDataComparePath /server1:"localhost" /db1:$dbName /empty2 /sf:"$lookupsPath" /Include:table:tbl_lk_.*