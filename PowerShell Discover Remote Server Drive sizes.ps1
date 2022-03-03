$A = Read-Host "Enter ServerName to discover drive sizes and freespace"
Get-WmiObject -Class Win32_LogicalDisk -ComputerName "$A" | 
Where-Object {$_.DriveType -eq 3} |
Select-Object DeviceID, Description,`
    @{"Label"="DiskSize(GB)";"Expression"={"{0:N}" -f ($_.Size/1GB) -as [float]}}, `
    @{"Label"="FreeSpace(GB)";"Expression"={"{0:N}" -f ($_.FreeSpace/1GB) -as [float]}} | FT -AutoSize