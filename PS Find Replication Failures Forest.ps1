$a = Read-Host "Enter FQDN name of Domain to Check IF Replcation failures in Forest"

Get-ADReplicationFailure -Target $a -Scope Forest