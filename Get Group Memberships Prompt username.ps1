$a = Read-Host "Enter Username to discover Domain Memberships"



Get-ADPrincipalGroupMembership $a | select name,groupscope