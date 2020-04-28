$pth = "$PSScriptRoot"
$WorkDir = "$pth"

$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-MicrosoftTeams -Credential $managedCred
#
$ReportName = "ovners2.csv"
#generate array for custom object
$teamsinfo = @()
$UsersArray = @()
#get all teams from organisation
$teams = get-team 
#find members, owner, guest


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
        "e.spiridonova1@dvorec.onmicrosoft.com",
        "p.Korshunov2354@dvorec.onmicrosoft.com",
        " ",
        "  "

    )




foreach($team in $teams){
  $displayname = ($team.DisplayName)
  $Description = ($team.Description)
  $groupid = $team.groupid

  $owner = (Get-TeamUser -GroupId $groupid -Role Owner).User

  $owner | ForEach-Object {

  $ow = $_
  $cond = 0
  $TeamsAdmin | ForEach-Object {
  
  if ($ow -eq $_){  
  $cond = 1  
  } 

  }
 
  if ($cond -eq 0){

  $UserObject = Select-Object @{n='GroupId';e={''}},@{n='DisplayName';e={''}},@{n='Owner';e={''}} -InputObject ''
   $UserObject.GroupId = $groupid
   $UserObject.DisplayName = $displayname
   $UserObject.Owner = $_   
   $UsersArray += $UserObject

  }
   
  
  }

}



 $UsersArray | 
ConvertTo-Csv -NoTypeInformation -Delimiter ";" | 
Out-File "$WorkDir\$ReportName" -Force -Encoding utf8 

