$pth = "$PSScriptRoot"
$WorkDir = "$pth\ts"



$TeamsAdmin = @(
        "a.samoshkin@dvorec.net", 
        "i.laptev@dvorec.net", 
        "YNPavlov@dvorec.net", 
        "v.abramov@dvorec.onmicrosoft.com", 
        "e.vasin@dvorec.onmicrosoft.com", 
        "test97@dvorec.net", 
        "test11111@dvorec.net", 
        "S.Yudin@dvorec.net", 
        "teamstest1@dvorec.onmicrosoft.com", 
        "A.Ovchinnikov@dvorec.net", 
        "p.korshunov@dvorec.net", 
        "e.spiridonova@dvorec.net", 
        "r.mitrofanov1@dvorec.onmicrosoft.com", 
        "v.abramov@dvorec.net", 
        "ds.kolesnikov@dvorec.net", 
        "m.smirnov@dvorec.net",
        "a.samoshkin@dvorec.onmicrosoft.com",
        "s.holod@dvorec.net",
        "e.spiridonova1@dvorec.onmicrosoft.com"

    )


$UsersActivityFile = "TeamsUserActivity_2020-04-20_2020-04-26.csv"
$normaliseName = "nm1.csv"

$teams = import-csv "$WorkDir\$teamsFile"  -Delimiter ";" 
$UsersActivity = import-csv "$WorkDir\$UsersActivityFile"  -Delimiter "," 



      

$teams | ForEach-Object {
$OW = ""
$CurentString = $_.Owner.Split(" ")
$CurentString = [System.Collections.ArrayList]$CurentString

$CurentString 
}