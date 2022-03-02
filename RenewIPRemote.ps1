write-host “—————————–”
write-host “DHCP lease renewal + flushDNS”
write-host “—————————–”
$machine = read-host “IP/Name of machine needing lease renewal ? ”
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $machine | Where { $_.IpEnabled -eq $true -and $_.DhcpEnabled -eq $true} | ForEach-Object -Process {$_.RenewDHCPLease()}
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $machine | Where { $_.IpEnabled -eq $true -and $_.DhcpEnabled -eq $true} | ForEach-Object -Process {ipconfig /flushdns}