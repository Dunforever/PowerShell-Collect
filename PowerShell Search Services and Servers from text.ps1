$Machines = Get-Content -Path "c:\Temp\servers.txt"
$Services = Get-Content -Path "c:\Temp\services.txt"
foreach ($computer in $machines){
Write-host "Checking if service is running on $computer" -b "green" -foregroundcolor "red"
Get-Service -Displayname $Services -ComputerName "$computer"
}