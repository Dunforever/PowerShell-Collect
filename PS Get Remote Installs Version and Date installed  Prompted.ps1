$A = Read-Host "Enter ServerName to Get Intalled Programs, Versions and Install Dates"
$properties = 'Name', 'Version', 'InstallDate'

Get-CimInstance -ClassName Win32_Product -ComputerName $A -Property $properties | Select-Object -Property $properties | Sort-Object Name