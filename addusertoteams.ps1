###
Import-Module MicrosoftTeams

$CenterName = "КнижнаяиПрикладнаяГрафика"
$pth = "$PSScriptRoot\$CenterName"

#
$ErrorActionPreference = "Stop"
$logDir = $pth
$timeStamp = Get-Date -Format "yyyyMMddHHmm"
$logFile = "PowerShell_transcript_$($timeStamp).txt"
#

Start-Transcript (Join-Path $logDir $logFile)

$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-MicrosoftTeams -Credential $managedCred

$Accounts = import-csv "$pth\o365Accounts.csv"  -Delimiter "," 



$Accounts | ForEach-Object{

Add-TeamUser -GroupId $_.GroupId -User $_.UserPrincipalName -Role Member

$_

Start-Sleep -s 3

Add-Content -Path "$pth\log.log" -Value $_


}


Disconnect-MicrosoftTeams


Stop-Transcript