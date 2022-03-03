$a = Read-Host "Enter FQDN of Domain to Check Replcation failures"

Get-ADReplicationFailure -Target $a -Scope Domain