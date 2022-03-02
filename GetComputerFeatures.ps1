$Comp = Read-Host "Enter Computer-Server Name to see all Features Installed"
Get-WindowsFeature -ComputerName $Comp | Where-Object {$_.InstallState -eq 'Installed'} | ft