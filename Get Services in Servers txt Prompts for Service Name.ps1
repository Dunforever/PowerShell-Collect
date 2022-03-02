$servicename = Read-Host "Enter ServiceName to check c:\temp\servers.txt servers for"

$list = get-content “c:\temp\servers.txt”

foreach ($server in $list) {

if (Get-Service $servicename -computername $server -ErrorAction 'SilentlyContinue'){

Write-Host "$servicename exists on $server "

# do something

}

else{write-host "No service $servicename found on $server."}
   Out-File c:\temp\ServerFromTextChecked.txt -Append

}