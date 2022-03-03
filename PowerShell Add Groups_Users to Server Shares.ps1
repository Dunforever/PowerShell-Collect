$c = Read-Host "Enter Share UNC Path"
$d = Read-Host "Enter Account Credentials domain\username to Add to Share"
$e = Read-Host "Enter Read, Modify or Full for Groups Access rights to Apply"

Grant-SmbShareAccess -Name $c -AccountName $d -AccessRight $e | Export-Csv c:\temp\GroupsAddedToShares.csv

