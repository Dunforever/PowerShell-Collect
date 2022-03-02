$zone = Read-Host "Enter Zone Name to Get Duplicates"
$DNSServerName = Read-Host "Enter DNS ServerName"
Get-DnsServerResourceRecord -ComputerName "$DNSServerName" -ZoneName "$zone" -RRType A |
select HostName,RecordType,@{Name='RecordData';Expression={$_.RecordData.IPv4Address}} |
export-csv "$env:userprofile\desktop\export.csv" -NoTypeInformation