$machines = Get-Content -Path "C:\temp\host2.txt"

ForEach($machine in $machines){
    $Version = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo
    "$machine - $Version" | Out-File C:\temp\Chrome_versions.txt -Append | FL
  }