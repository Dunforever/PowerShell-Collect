$TNCDetails = Read-Host "Enter IP Address of Machine to Get Network Details to CSV"
TNC $TNCDetails -InformationLevel Detailed | Export-Csv c:\temp\4Servers.csv -Append