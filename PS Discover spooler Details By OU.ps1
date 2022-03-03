Import-Module ActiveDirectory

$ou = Read-Host "Enter OU to check if spooler is running on servers like OU=Member Servers,DC=corp,DC=westworlds,DC=com"

$servers = Get-ADComputer -Filter * -SearchBase $ou | select-object -ExpandProperty Name

Foreach ($server in $servers){

    $Data = Get-Service -ServiceName *spooler* -ComputerName $server | select machinename,name,status | sort machinename | format-table -AutoSize 

    Write($Data) | Out-File .\CorpMemberServersOUSpoolerServices.txt -Append

}