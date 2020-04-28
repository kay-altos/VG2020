
$ErrorActionPreference = "Stop"
$pth = "$PSScriptRoot"
$logDir = $pth

#VARS#
$UserListPath ="$pth\AllOwnersRemastered" #в папке рядом со сриптом должен быть файл userlist.txt со списком UPN'ов пользователй
$UserRole = "Member" # роль - Member или Owner
$GroupId = "7eaa7ead-6b57-4384-b2a7-8d34fcc6941e" #ID комманды
$GetStoredCredentialTarget = "a.samoshkin_cloud" # имя сохранённой учётки - обязателньно в облаке
#WND VARS#

$timeStamp = Get-Date -Format "yyyyMMddHHmm"
$logFile = "PowerShell_transcript_$($timeStamp).txt"
#
Start-Transcript (Join-Path $logDir $logFile)
#
$managedCred = Get-StoredCredential -Target $GetStoredCredentialTarget
Connect-MicrosoftTeams -Credential $managedCred
#

Start-Sleep -s 3
#
$UserList = Get-Content -Path $UserListPath

$UserList | ForEach-Object {
#
    Add-TeamUser -GroupId $GroupId -User $_ -Role $UserRole
    
    $_
    $GroupId
    $UserRole

    Start-Sleep -s 3
  

}



Stop-Transcript