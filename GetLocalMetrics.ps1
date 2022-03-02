  [CmdletBinding()]
  param (
    [ValidateSet ("IPv4","IPv6")]
    [String]$AddressFamily
  )
  
  Get-NetIPInterface @PSBoundParameters | Sort-Object InterfaceMetric | ForEach-Object {
    if($_.InterfaceAlias -eq 1) { return; }
    $adapter= Get-NetAdapter
    $address=$_ | Get-NetIPAddress
       [PSCustomObject]@{
      InterfaceAlias=$_.InterfaceAlias;
      InterfaceIndex=$_.InterfaceIndex;
      Address="$($address.IPAddress)/$($address.PrefixLength)"
      Metric=$_.InterfaceMetric;
      Speed=$adapter.LinkSpeed
         }
  } | ft