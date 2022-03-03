$ErrorActionPreference = "silentlycontinue"

$Domain = Read-Host "`Enter Domain to ADD group from"
$UserName = Read-Host "`Enter Domain group name "
$DomName = $domain + "/" + $username
write-host "`n"
foreach($server in (gc .\servers.txt)){
$i= 0
$Boo= 0
if (Test-Connection $server -Count 1 -Quiet) {

$computer = [ADSI](”WinNT://” + $server + “,computer”)
$Group = $computer.psbase.children.find(”Administrators”)   
$members = @($group.psbase.Invoke("Members"))

$Check =($members | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}) -contains "$UserName"

If ($Check -eq $True) {
write-host "$server`t- Already Member" -foregroundcolor "yellow" }

else {

    $computer = [ADSI](”WinNT://” + $server + “,computer”)
    $Group = $computer.psbase.children.find(”Administrators”)
    $Group.Add("WinNT://" + $domain + "/" + $username)

    $mem = ($Group.psbase.invoke(”Members”) | %{$_.GetType().InvokeMember(”Adspath”, ‘GetProperty’, $null, $_, $null)}) `
    -replace ('WinNT://DOMAIN/' + $server + '/'), '' -replace ('WinNT://DOMAIN/', 'DOMAIN\') -replace ('WinNT://', '')
    $total = $mem.count

        Foreach ($member in $mem) {
            if ("$member" -eq "$Domain/$UserName"){
                write-host "$server`t- Successfully Added" -foregroundcolor "green"
                $Boo = 1 }
            $i=$i+1

            If ($total -eq $i -And $Boo -eq 0) {
            write-host "$server`t- Check Name - Doesn't exist or Server not ready" -foregroundcolor "magenta" }

        }       
}

}
else {
write-host "$server `t- Failed to connect to Group Name or Server" -foregroundcolor "Red" }   


}
write-host "`n"