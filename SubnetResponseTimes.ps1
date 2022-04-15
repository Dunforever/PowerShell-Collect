1..254| ForEach-Object -Process {
  Get-CimInstance -Class Win32_PingStatus -Filter ("Address='10.43.242.$_'") } |
    Select-Object -Property Address,ResponseTime,StatusCode | Export-Csv c:\temp\SubnetResponseTimes.csv -NoTypeInformation