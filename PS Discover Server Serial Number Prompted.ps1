$a = Read-Host "Enter ServerName to Discover Serial Number"
get-ciminstance -classname win32_bios -computername $a | format-list serialnumber