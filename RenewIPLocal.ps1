################################
$ethernet = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where { $_.IpEnabled -eq $true -and $_.DhcpEnabled -eq $true}  
foreach ($lan in $ethernet) {
       Write-Host "Flushing IP addresses" -ForegroundColor Yellow
       Sleep 2
       $lan.ReleaseDHCPLease() | out-Null
       Write-Host "Renewing IP Addresses" -ForegroundColor Green
       $lan.RenewDHCPLease() | out-Null
       Write-Host "The New Ip Address is "$lan.IPAddress" with Subnet "$lan.IPSubnet"" -ForegroundColor Yellow
       }
#############################################