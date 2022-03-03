$counter = 1
$comps = get-content C:\TEMP\HOSTLIST.txt
$dnsResults = "C:\TEMP\servershosttoIPS.csv"

function get-dnsres{
foreach ($comp in $comps) {
$TempIP = ([system.net.dns]::GetHostAddresses($comp)) | select IPAddressToString

$status = "Processing system {0} of {1}: {2}" -f $counter,$comps.Count,$comp
Write-Progress 'Resolving DNS' $status -PercentComplete ($counter/$comps.count * 100)
$counter++
$comp |
select @{Name='ComputerName';Expression={$comp}}, `
@{Name='ResolvesToIP';Expression={[system.net.dns]::GetHostAddresses($comp)}}, `
@{Name='IPResolvesTo';Expression={([system.net.dns]::GetHostEntry($TempIP.IPAddressToString)).HostName}}, `
@{Name='PingStatus'; Expression={ `
if ((get-wmiobject -query "SELECT * FROM Win32_PingStatus WHERE Address='$comp'").statuscode -eq 0) {'Host Online'} `
elseif ((get-wmiobject -query "SELECT * FROM Win32_PingStatus WHERE Address='$comp'").statuscode -eq 11003) {'Destination Host Unreachable'} `
elseif ((get-wmiobject -query "SELECT * FROM Win32_PingStatus WHERE Address='$comp'").statuscode -eq 11010) {'Request Timed Out'} `
elseif ((get-wmiobject -query "SELECT * FROM Win32_PingStatus WHERE Address='$comp'").statuscode -eq $Null) {'NoDNS'}
}
}
}
}

get-dnsres | export-csv $dnsResults -notypeinformation
invoke-item $dnsResults