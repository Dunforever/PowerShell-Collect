$a = Read-Host "Enter ServerName to see Network Adapter Details"

$properties = 'IPAddress', 'IPSubnet', 'DefaultIPGateway', 'MACAddress', 'DHCPEnabled',
'DHCPServer', 'DHCPLeaseObtained', 'DHCPLeaseExpires', 'Description'

Get-CimInstance -Class Win32_NetworkAdapterConfiguration -ComputerName $a | Select-Object $properties |FT