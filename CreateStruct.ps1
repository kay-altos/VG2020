#
$ErrorActionPreference = "Stop"
$CenterName = "CHO1"
$pth = "$PSScriptRoot\$CenterName"

$logDir = $pth
$timeStamp = Get-Date -Format "yyyyMMddHHmm"
$logFile = "PowerShell_transcript_$($timeStamp).txt"
#

new-item "$PSScriptRoot\$CenterName\" -itemtype directory
new-item "$PSScriptRoot\$CenterName\teams" -itemtype directory

Start-Transcript (Join-Path $logDir $logFile)

Import-Module -Name MicrosoftTeams
Import-Module AzureAD
Import-Module MSOnline




$managedCred = Get-StoredCredential -Target a.samoshkin_cloud

Connect-MicrosoftTeams -Credential $managedCred

Get-Team | Export-Csv -Path "$PSScriptRoot\$CenterName\teams.csv" -NoTypeInformation -Encoding UTF8

Disconnect-MicrosoftTeams


#
Stop-Transcript








