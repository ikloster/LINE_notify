$body = "`n"
foreach($line in [System.IO.File]::ReadLines("C:\vm-report.txt"))
{
	#$line
        $body = $body + $line + "`r`n"
	#$body
}
$body

$xx = @{message = "test"}
Write-Host $xx
