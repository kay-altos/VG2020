$pth = "$PSScriptRoot"
$Owners = Get-Content -Path "$pth\AllOwnersRemastered20042020"


$GetStoredCredentialTarget = "a.samoshkin_cloud"
$managedCred = Get-StoredCredential -Target $GetStoredCredentialTarget
Connect-AzureAD -Credential $managedCred

$UserMail = @()



$Owners | ForEach-Object {

    $domain = $_.Split("@")

    if ($domain[1] -eq "dvorec.onmicrosoft.com"){
       
      
      $UserMailObject = Select-Object @{n='TeamsUPN';e={''}},@{n='fullname';e={''}},@{n='email';e={''}} -InputObject ''

      $UserObject =  Get-AzureADUser -ObjectId $_  
      
      $ADUserObject = Get-ADUser -Filter{displayName -like $UserObject.DisplayName} -Properties EmailAddress
      
      $UserMailObject.fullname = $UserObject.DisplayName
      $UserMailObject.email = $ADUserObject.EmailAddress
      $UserMailObject.TeamsUPN = $_
      $UserMail += $UserMailObject

      Remove-Variable UserObject
      Remove-Variable UserMailObject
      Remove-Variable ADUserObject

    } else {
    
    
        $UserMailObject = Select-Object @{n='TeamsUPN';e={''}},@{n='fullname';e={''}},@{n='email';e={''}} -InputObject ''
        
        $ADUserObject = Get-ADUser -Filter{UserPrincipalName -Eq $_} -Properties EmailAddress
  
        $UserMailObject.fullname = $ADUserObject.Name
        $UserMailObject.email = $ADUserObject.EmailAddress
        $UserMailObject.TeamsUPN = $_
        $UserMail += $UserMailObject

        Remove-Variable UserMailObject
        Remove-Variable ADUserObject
    
    
    }
   

}

disconnect-AzureAD


$UserMail | 
ConvertTo-Csv -NoTypeInformation | 
% { $_ -replace '"', ""} |
Out-File "$pth\UserMail20042020.csv" -Force -Encoding utf8
#
Start-Sleep -s 30

Remove-Variable UserMail
Remove-Variable Owners
Remove-Variable domain