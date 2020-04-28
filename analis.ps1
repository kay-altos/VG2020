$pth = "$PSScriptRoot"
$WorkDir = "$pth\ts"

$TeamsAdmin = @(
        "a.samoshkin@dvorec.net", 
        "i.laptev@dvorec.net", 
        "YNPavlov@dvorec.net", 
        "v.abramov@dvorec.onmicrosoft.com", 
        "e.vasin@dvorec.onmicrosoft.com", 
        "test97@dvorec.net", 
        "test11111@dvorec.net", 
        "teamstest1@dvorec.onmicrosoft.com", 
        "A.Ovchinnikov@dvorec.net", 
        "p.korshunov@dvorec.net", 
        "e.spiridonova@dvorec.net", 
        "r.mitrofanov1@dvorec.onmicrosoft.com", 
        "v.abramov@dvorec.net", 
        "ds.kolesnikov@dvorec.net", 
        "m.smirnov@dvorec.net",
        "a.samoshkin@dvorec.onmicrosoft.com",
        "s.holod@dvorec.net",
        "i.laptev@dvorec.net",
        "S.Yudin@dvorec.net",
        "p.Korshunov2354@dvorec.onmicrosoft.com",
        "v.abramov@dvorec.onmicrosoft.com",
        "p.korshunov@dvorec.net",
        "a.kavun@dvorec.net",
        "s.shoshin@dvorec.net",
        "r.mitrofanov@dvorec.net",
        "V.Vechkanov@dvorec.net",
        "d.knyazev@dvorec.net"

    )










$teamsFile = "teams27042020.csv"
$UsersActivityFile = "TeamsUserActivity_2020-04-20_2020-04-26.csv"
$ReportName = "с_20_04_по_26_04.csv"

$teams = import-csv "$WorkDir\$teamsFile"  -Delimiter ";" 
$UsersActivity = import-csv "$WorkDir\$UsersActivityFile"  -Delimiter "," 
$team_stat = @()

$teams | ForEach-Object {

#$_.GroupId
#$_.DisplayName

$ChannelMessages = 0

$Id = 0
$DisplayName = 0
$EmailId = 0
$ChannelMessages  = 0
$ReplyMessages = 0
$PostMessages = 0
$ChatMessages = 0
$UrgentMessages = 0
$MeetingsOrganized = 0
$MeetingsParticipated = 0
$Calls1_1 = 0
$GroupCalls = 0
$AudioTime = 0
$VideoTime = 0
$ScreenShareTime = 0
$LastActivity = 0

#$Owners = $_.Owner
$Owners = ""


$CurentString = $_.Owner.Split(" ")

$CurentString = [System.Collections.ArrayList]$CurentString
      
For ($z=0; $z -lt $CurentString.Count; $z++) {
     
    For ($f=0; $f -lt $TeamsAdmin.Count; $f++) {
        if(([string]::Compare($CurentString[$z],$TeamsAdmin[$f],$true)) -eq 0){ 
            $CurentString.RemoveAt($z)
            if ($z -ne 0){
                $z--
            }
            
        }
    }
}


$CurentString | ForEach-Object {

    $cs = $_  

#@mailvg.ru
#dvorec.net

    if ($cs.split('@')[1] -eq "dvorec.net"){

        $cs = $cs.split('@')[0] + "@mailvg.ru"
    }

    $cond = 0
    $UsersActivity | ForEach-Object{
       
          if($cs -eq $_.Emailid){ 
            $cond = 1
        
            $ChannelMessages += $_.ChannelMessages
            $ReplyMessages += $_.ReplyMessages
            $PostMessages += $_.PostMessages
            $ChatMessages += $_.ChatMessages
            $UrgentMessages += $_.UrgentMessages
            $MeetingsOrganized += $_.MeetingsOrganized
            $MeetingsParticipated += $_.MeetingsParticipated
            $Calls1_1 += $_.'1:1 Calls'
            $GroupCalls += $_.GroupCalls
            $AudioTime += $_.'AudioTime (Minutes)'
            $VideoTime += $_.'VideoTime (Minutes)'
            $ScreenShareTime += $_.'ScreenShareTime (Minutes)'
            $Owners += " " + $_.Emailid + " "          
       
        }    
    
    }
    if ($cond -eq 0){
        $Owners += "Активности для данного пользователя за данный период: " + $cs + " не обнаруженно"
    
    }






}






$team_stat += [pscustomobject]@{
            GroupId = $_.GroupId
            DisplayName = $_.DisplayName
            Owners = $Owners
            ChannelMessages = $ChannelMessages
           # ReplyMessages = $ReplyMessages
           # PostMessages = $PostMessages
           # ChatMessages = $ChatMessages
           # UrgentMessages = $UrgentMessages
            MeetingsOrganized = $MeetingsOrganized
            MeetingsParticipated = $MeetingsParticipated
            Calls1_1 = $Calls1_1
            GroupCalls = $GroupCalls
            AudioTime = $AudioTime
            VideoTime = $VideoTime
            ScreenShareTime = $ScreenShareTime
                    
            }


            
        




}



$team_stat | 
ConvertTo-Csv -NoTypeInformation -Delimiter ";" | 
% { $_ -replace '"', ""} | 
% { $_ -replace 'GroupId', 'Идентификатор группы'} |
% { $_ -replace 'DisplayName', 'Отображаемое имя'} |
% { $_ -replace 'Owners', 'Учителя'} |
% { $_ -replace 'ChannelMessages', 'Всего сообщекний в группе'} |
#% { $_ -replace 'ReplyMessages', 'Ответных сообщений'} |
#% { $_ -replace 'PostMessages', 'Опубликованно сообщений'} |
#% { $_ -replace 'ChatMessages', 'Сообщений в чате'} |
#% { $_ -replace 'UrgentMessages', 'Сообщений помечанных как важные'} |
% { $_ -replace 'GroupCalls', 'Групповых звонков'} |
% { $_ -replace 'MeetingsOrganized', 'Организованно встречь'} |
% { $_ -replace 'MeetingsParticipated', 'Встречи в которых участвовал преподаватель'} |
% { $_ -replace 'Calls1_1', 'Звонков 1к1'} |
% { $_ -replace 'AudioTime', 'Время аудиозвонков (минуты)'} |
% { $_ -replace 'VideoTime', 'Время видео звонков (минуты)'} |
% { $_ -replace 'ScreenShareTime', 'Время демонстрации экрана (минуты)'} |

Out-File "D:\zametki\OneDrive - ГБПОУ Воробьевы горы\05_dev_1\05_10_O365\export\ts\$ReportName" -Force -Encoding utf8 
#
#>