$e=Read-Host "Enter ZoneName To Find Duplicates in"
$f=Read-Host "Enter ServerName that Hosts DNS"
Get-DnsServerResourceRecord -ComputerName $f -ZoneName $e -RRType A | select hostname,recordtype,timestamp,@{label='IP Address'; expression={$_.recorddata | select -ExpandProperty ipv4address}} | Export-CSV -Path c:\temp\ExportedDupesA.csv -NoTypeInformation