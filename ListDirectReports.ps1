Clear-host
Import-Module ActiveDirectory
Write-Host . LIST DIRECT REPORTS . -ForegroundColor white -BackgroundColor red
Write-Host
$Manager = Read-Host [ Enter Manager User Name ]
Write-Host
Write-Host ... These are Direct Reports to $Manager -ForegroundColor yellow
Write-Host
Get-ADUser -Identity $Manager -Properties directreports | select-object -ExpandProperty DirectReports