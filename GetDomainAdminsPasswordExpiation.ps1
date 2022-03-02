$Searcher = New-Object DirectoryServices.DirectorySearcher -Property @{

Filter = "(memberof=CN=Domain Admins,CN=Users,DC=salelytics,DC=local)"
PageSize = 500
}
$Searcher.FindAll() | ForEach-Object {
New-Object -TypeName PSCustomObject -Property @{
samaccountname = $_.Properties.samaccountname -join ''
pwdlastset = [datetime]::FromFileTime([int64]($_.Properties.pwdlastset -join ''))
}
} | Out-File c:\temp\DomainAdminsPassword.txt -Force