#$credential = Get-Credential
#$credential.Password | ConvertFrom-SecureString | Out-File C:\Users\a.samoshkin\Desktop\O365\cred


 #$securestring = Get-Content C:\Users\a.samoshkin\Desktop\O365\cred | ConvertFrom-SecureString

 #$securestring

#
 #$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList a.samoshkin@dvorec.onmicrosoft.com, $securestring


 #Connect-MsolService -Credential $Credentials

 <#
$credentials=Get-Credential 
New-StoredCredential -Credentials $credentials -Target a.samoshkin_cloud
$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-MicrosoftTeams -Credential $managedCred
Connect-msolService -Credential $managedCred
Disconnect-MicrosoftTeams



 #>


$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-msolService -Credential $managedCred
Disconnect-MicrosoftTeams
get-team | Out-GridView


<#
$password = ConvertTo-SecureString "HT92skn002125" -AsPlainText -Force

$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist a.samoshkin@dvorec.onmicrosoft.com, $password

Connect-MsolService -Credential $cred -Verbose 




#$session = New-CsOnlineSession -Credential $cred

Disconnect-MicrosoftTeams
#>



$credentials=Get-Credential


New-StoredCredential -Credentials $credentials -Target i.laptev_cloud