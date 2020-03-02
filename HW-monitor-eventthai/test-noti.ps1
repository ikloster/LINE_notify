# *** Send LINE notify ***

$txtPath = "C:\vm-report.txt"

$p = Import-CSV C:\vm-report.csv
$p | Select-Object Server, "CPU usage", "Memory usage", "C: FreeSpace"
$p | Format-Table | Out-File -FilePath $txtPath

$uri = 'https://notify-api.line.me/api/notify'
$token = 'Bearer nyHq1pqAAXwP4FrWCPZ7jogcQJNIS7deoWW5NlUmH2q'
$header = @{Authorization = $token}
#$body = @{message = 'PowerShell Notification'}
#$body = @{message = $p | Format-Table}
#$body = @{message = $p}

##$bodys = Get-Content C:\vm-report.csv
##foreach ($body in $bodys )
##{
##	$messagebody = $messagebody + $body + "`r`n"
##}

#$x = ``ncpu :`r`nram :`r`n`
$body2 = @{message = "`ncpu :`r`nram :`r`n"}

foreach($line in [System.IO.File]::ReadLines("C:\vm-report.txt"))
{
        #$line
        $body = $body + $line + "`r`n"
        #$body
}

#$body = @{message = "test"}

#$res = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body $body
$res = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -Body @{message =$body}
#$res = Invoke-RestMethod -Uri $uri -Method Post -Headers $header -InFile $txtPath -ContentType 'multipart/form-data'
#echo $res
$res
