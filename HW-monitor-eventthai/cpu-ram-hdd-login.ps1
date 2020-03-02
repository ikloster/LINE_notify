$txtFileServer = "C:\vm-Server.txt"
$csvFileReport = "C:\vm-Report.csv"
$txtFileReportTable = "C:\vm-Report-table.txt"
$txtFileReportList = "C:\vm-Report-list.txt"

GC $txtFileServer | % {
   $Comp = $_
   $Mem = ""
   If (Test-Connection $Comp -Quiet){
      $Mem = GWMI -Class win32_operatingsystem -computername $Comp
      New-Object PSObject -Property @{
         Server = $Comp
         "CPU usage" = "$((GWMI -ComputerName $Comp win32_processor | Measure-Object -property LoadPercentage -Average).Average) %"
         "Memory usage" = "$("{0:N2}" -f ((($Mem.TotalVisibleMemorySize - $Mem.FreePhysicalMemory)*100)/ $Mem.TotalVisibleMemorySize)) %"
         "C: FreeSpace" = "$("{0:N2}" -f ((Get-WmiObject -Class win32_Volume -ComputerName $Comp -Filter "DriveLetter = 'C:'" | Measure-Object -property FreeSpace -Sum).Sum /1GB)) GB"
      }
   }
   Else{
      "" | Select @{N="Server";E={$Comp}},"CPU usage","Memory usage","C: FreeSpace"
   }
}| Select Server,"CPU usage","Memory usage","C: FreeSpace" |
Export-Csv $csvFileReport -nti

$p = import-CSV $csvFileReport
# $p | out-gridview
($p | Format-Table | Out-String).Trim() | Out-File -FilePath $txtFileReportTable
($p | Format-List | Out-String).Trim() | Out-File -FilePath $txtFileReportList

# $css = @"
# <style>
# h1, h5, th { text-align: center; font-family: Segoe UI; }
# table { margin: auto; font-family: Segoe UI; box-shadow: 10px 10px 5px #888; border: thin ridge grey; }
# th { background: #0046c3; color: #fff; max-width: 400px; padding: 5px 10px; }
# td { font-size: 11px; padding: 5px 20px; color: #000; }
# tr { background: #b8d1f3; }
# tr:nth-child(even) { background: #dae5f4; }
# tr:nth-child(odd) { background: #b8d1f3; }
# </style>
# "@
# 
# Import-CSV C:\vm-report.csv | ConvertTo-Html -Head $css -Body "<h1>EventThai VM Report</h1>`n<h5>Generated on $(Get-Date)</h5>" | Out-File "C:\vm-report.html"

# *** Send LINE notify ***
$uri = 'https://notify-api.line.me/api/notify'
$token = 'Bearer nyHq1pqAAXwP4FrWCPZ7jogcQJNIS7deoWW5NlUmH2q'
$header = @{Authorization = $token}
# $body = @{message = 'PowerShell Notification'}

$body = Get-Date -UFormat "%d/%m/%Y, %T"
$body = "`n" + $body + "`n`n"

foreach($line in [System.IO.File]::ReadLines($txtFileReportList))
{
        #$line
        $body = $body + $line + "`r`n"
        #$body
}

#$res = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body $body 
$res = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body @{message =$body}
echo $res
