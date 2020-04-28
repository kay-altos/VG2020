
$usernames = Get-Content C:\Users\a.samoshkin\Desktop\O365\24032020.txt -Encoding UTF8





$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-msolService -Credential $managedCred

$usernames | ForEach-Object{


Remove-MsolUser -UserPrincipalName $_ -Force

$_



}



