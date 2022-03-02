$ServerList = Get-Content C:\temp\Servers.txt
foreach ($server in $ServerList)
{
quser /server:$server | ? { $_ -match “Disc” }|foreach {
$Session = ($_ -split ‘ +’)[2]
$user = ($_ -split ‘ +’)[1]
$idletime= ($_ -split ‘ +’)[4]
Write-host “You are about to log off user $user with session id $Session who is idle for $idletime ”
logoff $Session /server:$server
}
}