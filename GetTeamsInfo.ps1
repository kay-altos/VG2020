$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-MicrosoftTeams -Credential $managedCred
#

#generate array for custom object
$teamsinfo = @()
#get all teams from organisation
$teams = get-team 
#find members, owner, guest
foreach($team in $teams){
  $displayname = ($team.DisplayName)
  $Description = ($team.Description)
  $groupid = $team.groupid
  $members = (Get-TeamUser -GroupId $groupid -Role Member).User

  $owner = (Get-TeamUser -GroupId $groupid -Role Owner).User
  $guests = (Get-TeamUser -GroupId $groupid -Role Guest).User
   #custom object for output
  $teamsinfo += [pscustomobject]@{
    GroupId   = $groupid
    DisplayName   = $displayname
    Owner = ("$owner")
    Members = ("$members")
    Guests = ("$guests")
    Description = ("$Description")
  }
}
#show teaminformation in OutGrid-View
$teamsinfo | Sort-Object DisplayName | Out-GridView -Title "All Office365 Groups created in MS Teams" 


$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6264A7;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@
$htmlreport = $teamsinfo | ConvertTo-Html -Head $Header 
$htmlreport | Out-File C:\Users\a.samoshkin\Desktop\O365\export\teams27042020.html
#Invoke-Item .\teams.html

$teamsinfo | Export-Csv -Path C:\Users\a.samoshkin\Desktop\O365\export\teams27042020.csv -Encoding UTF8 -Delimiter ";" -Force

