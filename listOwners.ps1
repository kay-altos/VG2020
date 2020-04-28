$pth = "$PSScriptRoot"
$RawListOwners = Get-Content -Path "$pth\AllOwners20042020"

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
        "s.holod@dvorec.net"

    )


$UsersArray = @()
$DublicateUsersArray = @()

$UserObject = Select-Object @{n='fullname';e={''}},@{n='groupid';e={''}},@{n='upn';e={''}} -InputObject ''

$RawListOwners | ForEach-Object {

   $CurentString = $_.Split(" ")
   $CurentString | ForEach-Object {
        $UserObject = Select-Object @{n='fullname';e={''}} -InputObject ''
        $UserObject.fullname  = $_
        $UsersArray += $UserObject
        
        }
    }

$UsersArray = [System.Collections.ArrayList]$UsersArray
$DublicateUsersArray = @()

For ($i=0; $i -lt $UsersArray.Count; $i++) {   
    For ($j=$i+1; $j -lt $UsersArray.Count; $j++) {
        if(([string]::Compare($UsersArray.fullname[$i],$UsersArray.fullname[$j],$true)) -eq 0){ 
        
        $UsersArray.RemoveAt($j)
        $j--
              
        }
    }
}
Start-Sleep -s 3


For ($z=0; $z -lt $UsersArray.Count; $z++) {     
    For ($f=0; $f -lt $TeamsAdmin.Count; $f++) {
        if(([string]::Compare($UsersArray.fullname[$z],$TeamsAdmin[$f],$true)) -eq 0){ 
            $UsersArray.RemoveAt($z)
            $z--
        }
    }
}

$OutExist =  Test-Path -Path "$pth\AllOwnersRemastered20042020"

if ($OutExist) {

    Remove-Item -Path  "$pth\AllOwnersRemastered20042020" -Force

}

$UsersArray | ForEach-Object {

    Add-Content -Path "$pth\AllOwnersRemastered20042020" -Value $_.fullname -Encoding UTF8
    $_.fullname

}





 