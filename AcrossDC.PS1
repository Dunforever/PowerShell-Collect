$a = Read-Host "Enter the Port For OutGrid View Across Domain"

# Get your ad domain
$DomainName = (Get-ADDomain).DNSRoot
  
# Get all DC's
$AllDCs = Get-ADDomainController -Filter * -Server $DomainName

# Using one-liner - Get all DC's and test connection on port 3269
(Get-ADDomainController -Filter * -Server $((Get-ADDomain).DNSRoot)).Hostname | 
Foreach{Test-NetConnection -ComputerName $_ -Port $a -InformationLevel Detailed} | 
Out-GridView -Title "Results"