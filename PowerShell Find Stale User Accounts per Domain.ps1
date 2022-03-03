# Gets time stamps for all User in the domain that have NOT logged in since after specified date
import-module activedirectory 
$domain = Read-Host "Enter FQDN of domain to discover users not logged in" 
$DaysInactive = Read-Host "Enter Number of Days to Search" 
$time = (Get-Date).Adddays(-($DaysInactive))
 
# Get all AD User with lastLogonTimestamp less than our time and set to enable
Get-ADUser -Filter {LastLogonTimeStamp -lt $time -and enabled -eq $true} -Properties LastLogonTimeStamp |
 
# Output Name and lastLogonTimestamp into CSV
select-object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} | export-csv c:\temp\DaysNotLoggedIntoDomain.csv -notypeinformation