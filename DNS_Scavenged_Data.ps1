#*==========================================================================================================================*#
# Email about DNS Scavenging and all DNS Scavenged Records
#*==========================================================================================================================*#
# Script Created By     :       Ashish Gupta
# Date                  :       11th December 2017
#*==========================================================================================================================*#
# Check Scavenged_Records.csv and delete it to create the new one.
#*==========================================================================================================================*#
$recordfile = "C:\temp\Scavenged_Records.txt"
if (Test-Path ($recordfile))
{
	Remove-Item $recordfile
}
#*==========================================================================================================================*#
# Fetch main DNS Scavenging event 2501 and check if it is new or old.
#*==========================================================================================================================*#
$2501 = Get-WinEvent -LogName "DNS Server" | Where-Object {$_.Id -eq "2501"} | Select-Object -First 1 -Property *
$2501Date = $2501.TimeCreated
$2501Message = $2501.Message
[int] $2501ScavangedRecords = $2501Message.Split("=")[4].Trim(" ").Split(".")[0]
#*==========================================================================================================================*#
# Fetch all scavenged records with the event id 521.
#*==========================================================================================================================*#
$MyArray = $null
$MyArray = @()

$521Events = Get-WinEvent -LogName "Microsoft-Windows-DNSServer/Audit" | Where-Object {$_.id -eq "521"} | Select-Object -First "$2501ScavangedRecords"
foreach ($521Event in $521Events){
$MyObj = "" | Select "SystemRecord", "Zone", "Time"

$521RecordName = $521Event.Message.Split(",")[1].Split(" ")[2].Trim()
$521Zone = $521Event.Message.Split(",")[2].Split(" ")[-1].Trim(".")
$521Time = $521Event.TimeCreated

$MyObj.SystemRecord = $521RecordName
$MyObj.Zone = $521Zone
$MyObj.Time = $521Time

$MyArray += $MyObj
$MyObj = $null

}
$MyArray | Out-File $recordfile -Force

#*==========================================================================================================================*#
# End of the Script.
#*==========================================================================================================================*#