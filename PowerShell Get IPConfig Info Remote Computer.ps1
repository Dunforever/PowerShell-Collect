#####################################################################
####  This script reads IP configuration from remote computer
####
#####################################################################
####  Author: Andrew Karmadanov
#####################################################################
#####################################################################

#####################################################################################################
####   INITIALIZING THE VARIABLES   #################################################################
#####################################################################################################
$InfoMessage = $Host.PrivateData.WarningForeGroundColor
$ErrorMessage = $Host.PrivateData.ErrorForeGroundColor
$WMIDateTime = new-object -com "WbemScripting.SWbemDateTime"
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

$ComputerName = Read-Host "Enter the computer name or IP address" 
$WMIObject = $null
$WMIObject = Get-WMIObject -class Win32_PingStatus -filter ("Address = '" + $ComputerName + "'")
if ($WMIObject.StatusCode -eq $Null)
{
	Write-Host ("The computer name " + $ComputerName + " cannot be resolved") -foregroundColor $ErrorColor
	return
}
if ($WMIObject.StatusCode -ne 0)
{
	Write-Host ($ComputerName + " is not pingable" + (PingStatus($WMIObject.StatusCode))) -foregroundColor $ErrorColor
	return
}

$WMIObject = $null
$WMIObject = Get-WMIObject -class Win32_OperatingSystem -computerName $ComputerName -errorAction SilentlyContinue
if ($WMIObject -eq $null)
{
	Write-Host ("WMI doesn't work on " + $ComputerName) -foregroundColor $ErrorColor
	return
}

$IPEnabledOnlyString = Read-Host "Do you want to display IP-Enabled adapters only? (Y/N)" 
if ($IPEnabledOnlyString -eq "")
	{$IPEnabledOnlyString = "Y"}
if ($IPEnabledOnlyString.ToUpper()[0] -eq "Y")
	{$IPEnabledOnly = $True}
else
	{$IPEnabledOnly = $False}

$ComputerName = [System.Net.Dns]::Resolve($ComputerName).addresslist[0].IPAddressToString

#####################################################################################################
####   MAIN LOOP   ##################################################################################
#####################################################################################################

Write-Host

$WMIObject = Get-WmiObject -class Win32_SystemEnclosure	-computername $ComputerName
if ($WMIObject.Count -ne $Null)
	{$WMIObject = $WMIObject[0]}
$SerialNumber = $WMIObject.SerialNumber

$WMIObject = Get-WMIObject -class Win32_ComputerSystem -computername $ComputerName
Write-Host ("COMPUTER : " + $WMIObject.Name) -foregroundColor $ErrorMessage
Write-Host ("MANUFACTURER : " + $WMIObject.Manufacturer.Trim() + ", " + "MODEL : " + $WMIObject.Model.Trim() +", " + "SERIAL : " + $SerialNumber)  -foregroundColor $ErrorMessage
Write-Host ("USER : " + $WMIObject.UserName) -foregroundColor $ErrorMessage

$WMIObject = get-wmiobject -class Win32_OperatingSystem -computername $ComputerName
$Line = ""
ForEach ($objItem in $WMIObject)
	{Write-Host ("OS : " + $objItem.Caption + ", SP " + $objItem.ServicePackMajorVersion) -foregroundColor $ErrorMessage}

$NetworkAdapters = Get-WmiObject -class Win32_NetworkAdapterConfiguration	-computername $ComputerName
ForEach ($NetworkAdapter in $NetworkAdapters)
{
	if ($IPEnabledOnly)
		{if (-not ($NetworkAdapter.IPEnabled))
			{Continue}}
#IP
	Write-Host
	Write-Host $NetworkAdapter.Caption.Substring($NetworkAdapter.Caption.IndexOf("]")+2)  -foregroundColor $InfoMessage
	Write-Host "   IP Address..........................." -noNewLine 
	ForEach ($Item in $NetworkAdapter.IPAddress)
		{Write-Host ($Item + "  ") -noNewLine}
	Write-Host
	Write-Host "   Subnet Mask.........................." -noNewLine
	ForEach ($Item in $NetworkAdapter.IPSubnet)
		{Write-Host ($Item + "  ") -noNewLine}
	Write-Host
	Write-Host "   Default Gateway......................" -noNewLine
	ForEach ($Item in $NetworkAdapter.DefaultIPGateway)
		{Write-Host ($Item + "  ") -noNewLine}
	Write-Host
	Write-Host ("   MAC Address.........................." + $NetworkAdapter.MACAddress)                   #: 00:0F:1F:BE:AC:1C

#DHCP	
	Write-Host
	Write-Host ("   DHCP Enabled........................." + ($NetworkAdapter.DHCPEnabled.ToString()).ToUpper())
	if ($NetworkAdapter.DHCPEnabled)
	{
		if (($NetworkAdapter.DHCPServer -ne $Null) -and ($NetworkAdapter.DHCPServer -ne ""))
		{
			Write-Host ("   DHCP Server.........................." + $NetworkAdapter.DHCPServer)
			$WMIDateTime.Value = $NetworkAdapter.DHCPLeaseObtained
			Write-Host ("   DHCP Lease Obtained.................." + ($WMIDateTime.GetVarDate()).ToString())
			$WMIDateTime.Value = $NetworkAdapter.DHCPLeaseExpires
			Write-Host ("   DHCP Lease Expires..................."  + ($WMIDateTime.GetVarDate()).ToString())
		}
	}
	
#DNS	
	if ($NetworkAdapter.IPEnabled)
	{
		Write-Host
		Write-Host "   DNS Servers.........................." -noNewLine
		ForEach ($Item in $NetworkAdapter.DNSServerSearchOrder)
			{Write-Host ($Item + "  ") -noNewLine}
		Write-Host
		if ($NetworkAdapter.DNSDomain -ne $Null)
			{Write-Host ("   Domain Name.........................." + $NetworkAdapter.DNSDomain.ToUpper())}
		if ($NetworkAdapter.DNSDomainSuffixSearchOrder -ne $Null)
		{
			Write-Host "   DNS Domain Suffix Search Order......." -noNewLine
			ForEach ($Item in $NetworkAdapter.DNSDomainSuffixSearchOrder)
				{Write-Host ($Item + "  ") -noNewLine}
			Write-Host
		}
		Write-Host ("   DNS Enabled For WINS Resolution......" + ($NetworkAdapter.DNSEnabledForWINSResolution.ToString()).ToUpper())
		Write-Host ("   Domain DNS Registration Enabled......" + ($NetworkAdapter.DomainDNSRegistrationEnabled.ToString()).ToUpper())
		Write-Host ("   Full DNS Registration Enabled........" + ($NetworkAdapter.FullDNSRegistrationEnabled.ToString()).ToUpper())

#WINS	
		Write-Host
		Write-Host ("   WINS Servers........................." + $NetworkAdapter.WINSPrimaryServer + "  " + $NetworkAdapter.WINSSecondaryServer)
		Write-Host ("   WINS Enable LMHosts Lookup..........." + ($NetworkAdapter.WINSEnableLMHostsLookup.ToString()).ToUpper())
		Write-Host ("   WINS Host Lookup File................" + $NetworkAdapter.WINSHostLookupFile)
	}
#SERVICE
	Write-Host
	Write-Host ("   ServiceName.........................." + $NetworkAdapter.ServiceName)
}
return

