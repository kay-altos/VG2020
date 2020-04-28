### 
$CenterName = "ДОН"
$pth = "$PSScriptRoot\$CenterName"
$LicenseAssignment = "dvorec:STANDARDWOFFPACK_IW_STUDENT"
$UsageLocation = "RU"
$UsersArray = @()
$utfilename = "ut.csv"
### 
$ErrorActionPreference = "Stop"
$logDir = $pth
$timeStamp = Get-Date -Format "yyyyMMddHHmm"
$logFile = "PowerShell_transcript_$($timeStamp).txt"
#
Start-Transcript (Join-Path $logDir $logFile)
#
$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-msolService -Credential $managedCred
Connect-MicrosoftTeams -Credential $managedCred
#
function Translit
{
    param([string]$inString)
    $Translit = @{ 
    [char]'а' = "a"
    [char]'А' = "A"
    [char]'б' = "b"
    [char]'Б' = "B"
    [char]'в' = "v"
    [char]'В' = "V"
    [char]'г' = "g"
    [char]'Г' = "G"
    [char]'д' = "d"
    [char]'Д' = "D"
    [char]'е' = "e"
    [char]'Е' = "E"
    [char]'ё' = "yo"
    [char]'Ё' = "Yo"
    [char]'ж' = "zh"
    [char]'Ж' = "Zh"
    [char]'з' = "z"
    [char]'З' = "Z"
    [char]'и' = "i"
    [char]'И' = "I"
    [char]'й' = "j"
    [char]'Й' = "J"
    [char]'к' = "k"
    [char]'К' = "K"
    [char]'л' = "l"
    [char]'Л' = "L"
    [char]'м' = "m"
    [char]'М' = "M"
    [char]'н' = "n"
    [char]'Н' = "N"
    [char]'о' = "o"
    [char]'О' = "O"
    [char]'п' = "p"
    [char]'П' = "P"
    [char]'р' = "r"
    [char]'Р' = "R"
    [char]'с' = "s"
    [char]'С' = "S"
    [char]'т' = "t"
    [char]'Т' = "T"
    [char]'у' = "u"
    [char]'У' = "U"
    [char]'ф' = "f"
    [char]'Ф' = "F"
    [char]'х' = "h"
    [char]'Х' = "H"
    [char]'ц' = "c"
    [char]'Ц' = "C"
    [char]'ч' = "ch"
    [char]'Ч' = "Ch"
    [char]'ш' = "sh"
    [char]'Ш' = "Sh"
    [char]'щ' = "sch"
    [char]'Щ' = "Sch"
    [char]'ъ' = ""
    [char]'Ъ' = ""
    [char]'ы' = "y"
    [char]'Ы' = "Y"
    [char]'ь' = ""
    [char]'Ь' = ""
    [char]'э' = "e"
    [char]'Э' = "E"
    [char]'ю' = "yu"
    [char]'Ю' = "Yu"
    [char]'я' = "ya"
    [char]'Я' = "Ya"
    }
    $outCHR=""
    foreach ($CHR in $inCHR = $inString.ToCharArray())
        {
        if ($Translit[$CHR] -cne $Null ) 
            {$outCHR += $Translit[$CHR]}
        else
            {$outCHR += $CHR}
        }

    $rnd = Get-Random -Minimum 999 -Maximum 99999
    $out = $outCHR+$rnd
    Write-Output $out
 }

$ut = import-csv "$pth\$utfilename"  -Delimiter ";" -Encoding UTF8
$ut = [System.Collections.ArrayList]$ut
$DublicateUsersArray = @()

For ($i=0; $i -lt $ut.Count; $i++) {
    #
    #$ut[$i]
    $percentsMain = ($i*100)/$ut.Count
    #
    Write-Progress -Activity Updating -Status 'Progress->' -PercentComplete $percentsMain -CurrentOperation Main
    #
    $fName = $ut.fullname[$i] | % { $ut.fullname[$i].Split(' ')[1] } 
    $ffName = $ut.fullname[$i] | % { $ut.fullname[$i].Split(' ')[2] } 
    $lName = $ut.fullname[$i] | % { $ut.fullname[$i].Split(' ')[0] }
    $surname = $lName
    $firstname = $fName
    $firstname = $firstname.substring(0,1)
    $firstname = $firstname -replace "$","."
    $firstname = $firstname.ToLower()
    $surname = $surname.ToLower()
    $rUsrName = $firstname+$surname
    $login = Translit($rUsrName)
    $upn = $login + '@dvorec.onmicrosoft.com'
    $ut[$i].upn = $upn
       
    For ($j=$i+1; $j -lt $ut.Count; $j++) {
        #
        $percentsFindDubl = ($j*100)/$ut.Count
        Write-Progress -Id 1 -Activity Updating -Status 'Progress' -PercentComplete $percentsFindDubl -CurrentOperation FindDubl
        #
        $origngroup = $ut.groupid[$i]

        if(([string]::Compare($ut.fullname[$i],$ut.fullname[$j],$true)) -eq 0){ 
            $DublicatUserObject = Select-Object @{n='fullname';e={''}},@{n='groupid';e={''}},@{n='upn';e={''}} -InputObject ''
            $DublicatUserObject.upn = $upn
            $DublicatUserObject.fullname = $ut.fullname[$i]
            $DublicatUserObject.groupid  += $ut.groupid[$j]
            $DublicateUsersArray += $DublicatUserObject
            $ut.RemoveAt($j)
            $j--
        }
    }
}
Start-Sleep -s 3

$DublicateUsersArray
echo "-----------------"
$ut
Start-Sleep -s 3
$DublicateUsersArray | Export-Csv -Path "$pth\DublicateUsers_$CenterName.csv" -Delimiter ";" -Encoding UTF8 -NoTypeInformation
Start-Sleep -s 3
$ut | Export-Csv -Path "$pth\Users_$CenterName.csv" -Delimiter ";" -Encoding UTF8 -NoTypeInformation
Start-Sleep -s 30
#
$users = import-csv "$pth\Users_$CenterName.csv"  -Delimiter ";" -Encoding UTF8
Start-Sleep -s 3
#
$users | ForEach-Object {
#
    $newMsolUser = New-MsolUser -DisplayName $_.fullname -UserPrincipalName $_.upn -UsageLocation $UsageLocation -ForceChangePassword $false  -LicenseAssignment $LicenseAssignment
    #
    #$_.upn
    $newMsolUser
    Start-Sleep -s 3
            #
            if ($newMsolUser.Password)
            {
                $UserObject = Select-Object @{n='FullName';e={''}},@{n='UserPrincipalName';e={''}},@{n='Password';e={''}},@{n='Team';e={''}},@{n='GroupId';e={''}} -InputObject ''
                $UserObject.Team = $_.groupname
                $UserObject.FullName = $_.fullname
                $UserObject.GroupId = $_.groupid
                $UserObject.UserPrincipalName = $newMsolUser.UserPrincipalName
                $UserObject.Password  = $newMsolUser.Password             
                $UsersArray += $UserObject
            }

}

$UsersArray
#
$UsersArray | 
ConvertTo-Csv -NoTypeInformation | 
% { $_ -replace '"', ""} |
Out-File "$pth\o365Accounts_$CenterName.csv" -Force -Encoding utf8
#
Start-Sleep -s 30

$accountsforteams = import-csv "$pth\o365Accounts_$CenterName.csv"  -Delimiter "," 
$doubleaccountsforteams = import-csv "$pth\DublicateUsers_$CenterName.csv"  -Delimiter ";" 
#




Stop-Transcript