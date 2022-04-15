Import-Module ActiveDirectory
 
$keyword = Read-Host "Enter Keyword"
$eventid = Read-Host "Enter EventID"
$logname = Read-Host "Enter the name of log you want to search, application, security, etc."
 
$domains = (Get-ADForest).domains
$dcs = Foreach ($domain in $domains) {
     Get-ADDomainController -Filter *|Select Name -ExpandProperty Name|sort-object|get-unique
}
$events = ForEach ($dc in $dcs) {
     Get-EventLog  -ComputerName $dc -LogName $logname -InstanceId $eventid -Message *$keyword*|Select-Object -Property *
}
$events|out-file c:\temp\dc_log_search.txt