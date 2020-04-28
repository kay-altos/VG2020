#
$ErrorActionPreference = "Stop"
$CenterName = "КнижнаяиПрикладнаяГрафика"
$pth = "$PSScriptRoot\$CenterName"

$logDir = $pth
$timeStamp = Get-Date -Format "yyyyMMddHHmm"
$logFile = "PowerShell_transcript_$($timeStamp).txt"
#
Start-Transcript (Join-Path $logDir $logFile)
#

$managedCred = Get-StoredCredential -Target a.samoshkin_cloud
Connect-msolService -Credential $managedCred
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
 
### 

$teams = $(Get-ChildItem "$pth\teams").Name
$t = import-csv "$pth\teams.csv"  -Delimiter ";" -Encoding UTF8
$UsersArray = @()
###

$teams | ForEach-Object {
#
$usernames = Get-Content "$pth\teams\$_" -Encoding UTF8
$fullname = $_
#
$t | ForEach-Object {

    if($fullname -eq $_.GroupId){

        $tInfo = $_
 
        $usernames | ForEach-Object {

            $fName = $_ | % { $_.Split(' ')[1] } 
            $ffName = $_ | % { $_.Split(' ')[2] } 
            $lName = $_ | % { $_.Split(' ')[0] }
            $surname = $lName
            $firstname = $fName
            $firstname = $firstname.substring(0,1)
            $firstname = $firstname -replace "$","."
            $firstname = $firstname.ToLower()
            $surname = $surname.ToLower()
            $rUsrName = $firstname+$surname
            $login = Translit($rUsrName)
            $upn = $login + '@dvorec.onmicrosoft.com'          
            $newMsolUser = New-MsolUser -DisplayName $_ -FirstName $fName -LastName $lName -UserPrincipalName $upn -UsageLocation RU -ForceChangePassword $false  -LicenseAssignment dvorec:STANDARDWOFFPACK_IW_STUDENT
            #
            #$upn
            $newMsolUser
           
            #
            Start-Sleep -s 3
            #
            if ($newMsolUser.Password)
            {
                $UserObject = Select-Object @{n='UserPrincipalName';e={''}},@{n='Password';e={''}},@{n='Team';e={''}},@{n='GroupId';e={''}} -InputObject ''
                $UserObject.Team = $tInfo.DisplayName
                $UserObject.GroupId = $tInfo.GroupId
                $UserObject.UserPrincipalName = $newMsolUser.UserPrincipalName
                $UserObject.Password  = $newMsolUser.Password             
                $UsersArray += $UserObject
            }
        }
    }
}
}

$UsersArray | 
ConvertTo-Csv -NoTypeInformation | 
% { $_ -replace '"', ""} |
Out-File "$PSScriptRoot\$CenterName\o365Accounts.csv" -Force -Encoding utf8
#
Stop-Transcript