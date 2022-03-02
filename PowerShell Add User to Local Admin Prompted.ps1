$DomainName = Read-Host "Enter FQDN Domain Name of User"
$ComputerName = Read-Host "Enter Host Name"
$UserName = Read-Host "Username To Add to Local Admin Group"
$AdminGroup = [ADSI]"WinNT://$ComputerName/Administrators,group"
$User = [ADSI]"WinNT://$DomainName/$UserName,user"
$AdminGroup.Add($User.Path)