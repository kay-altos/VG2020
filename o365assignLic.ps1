###

$CenterName = "Ясенево"
$pth = "$PSScriptRoot\$CenterName"
$planName="dvorec:STANDARDWOFFPACK_IW_FACULTY"
#
$ErrorActionPreference = "Stop"
$logDir = $pth
$timeStamp = Get-Date -Format "yyyyMMddHHmm"
$logFile = "PowerShell_transcript_$($timeStamp).txt"
#
Start-Transcript (Join-Path $logDir $logFile)


Import-Module AzureAD
$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-msolService -Credential $managedCred
#

$userlist = import-csv "$pth\userlist.csv"  -Delimiter "," 

#$userUPN="test97@dvorec.net"


$userlist | ForEach-Object{

$userUPN=$_.upn

Get-MsolUser -UserPrincipalName $userUPN

#must be lic
if(!($(Get-MsolUser -UserPrincipalName $userUPN).isLicensed)){

Set-MsolUser -UserPrincipalName $userUPN -UsageLocation RU
Start-Sleep -s 3
Set-MsolUserLicense -UserPrincipalName $userUPN -AddLicenses $planName


}



Start-Sleep -s 3

Get-MsolUser -UserPrincipalName $userUPN
Add-Content -Path "$pth\log.log" -Value $_

}


Disconnect-MicrosoftTeams
Stop-Transcript