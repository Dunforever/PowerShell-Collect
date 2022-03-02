$UserNamesList = get-content -path "C:\temp\UserNames.txt"
$ExportPath = "C:\temp\WhenUsersLastLoggedIn.csv"
 
foreach ($name in $UserNamesList){
 
Get-ADUser -Identity $name -Server WPW00070.prod.westworlds.com -Properties LastLogonDate, LastLogonTimestamp | Select Name, SamAccountName, LastLogonDate, LastLogonTimestamp | Export-CSV $ExportPath -Append -NoTypeInformation
 
}
