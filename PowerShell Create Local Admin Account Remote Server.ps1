#Script Creates local admin defined, Adds doesn't expire, user cannot change password, and password defined below is set as 'SuperSecretP@ssw0rd1' change to preference
#Replace line below for OU defined search and add local admin - all computers in OU
#$computers = Get-ADComputer -filter * -SearchBase "OU=Test OU,OU=Computers,OU=sOU,DC=domain,DC=local"


$userName = Read-Host "Enter Local Account name to create"
$password = ConvertTo-SecureString -String 'SuperSecretP@ssw0rd1' -AsPlainText -Force
$group = 'Administrators'
$computers = Read-Host "Enter ServerName to add a local admin account to"
foreach ($comp in $Computers) 
{

Invoke-Command -ComputerName $comp.Name -ArgumentList $userName, $password, $group -ScriptBlock {
    New-LocalUser -Name $args[0] -FullName 'Local Admin' -Description 'Local Admin Account' -Password $args[1] -PasswordNeverExpires -AccountNeverExpires -UserMayNotChangePassword
    Add-LocalGroupMember -Group $args[2] -Member $args[0]
}
}
