Add-Type -AssemblyName System.Web
[System.Web.Security.Membership]::GeneratePassword(16,3)
Start-Sleep -s 10