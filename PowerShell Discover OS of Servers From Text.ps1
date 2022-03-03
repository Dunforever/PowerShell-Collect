#Create c:\temp\computers.txt and place server names top to bottom "not fqdn" and make certain no spaces behind names

#If Not on a DC run 'Import-Module ActiveDirectory' from a same Domain management box.

$Computers = Import-CSV -Path "c:\temp\computers.txt" -Header "Name"
ForEach ($Computer In $Computers)
{
Try
{
Get-ADComputer -Identity $Computer.Name -Properties Name, operatingSystem | Select Name, operatingSystem
}
Catch
{
$Computer.Name +  " Server is not on this Domain, is vaulted, or is not reachable"
}
}