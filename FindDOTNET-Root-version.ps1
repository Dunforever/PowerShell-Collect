$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $machine)
$regKey = $reg.OpenSubKey("SOFTWARE\\Microsoft\\ASP.NET")
$regKey.GetValue("RootVer")