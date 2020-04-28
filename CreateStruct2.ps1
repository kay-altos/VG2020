#
$ErrorActionPreference = "Stop"
$CenterName = "CHO1"
$pth = "$PSScriptRoot\$CenterName"
$logDir = $pth
#
$timeStamp = Get-Date -Format "yyyyMMddHHmm"
$logFile = "PowerShell_transcript_$($timeStamp).txt"
#
Start-Transcript (Join-Path $logDir $logFile)


new-item "$PSScriptRoot\$CenterName\teams" -itemtype directory -Force


$teams = import-csv "$PSScriptRoot\$CenterName\teams.csv"  -Delimiter "," 

$teams | 
ForEach-Object {
    $id = $_.GroupId
    New-Item -Path "$PSScriptRoot\$CenterName\teams\$id" -ItemType File 
}


$(Get-ChildItem $PSScriptRoot\$CenterName\teams).Name

#
Stop-Transcript