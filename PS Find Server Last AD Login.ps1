$a = Read-Host "Enter ServerName to Discover Server's Last AD Login"

Get-ADComputer -identity $a -Properties * | FT Name, LastLogonDate -Autosize