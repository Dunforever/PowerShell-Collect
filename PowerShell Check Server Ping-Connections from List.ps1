 ForEach ($COMPUTER in (gc c:\temp\testing2ou.txt)) 
{if(!(Test-Connection -Cn $computer -BufferSize 16 -Count 1 -ea 0 -quiet))
 
{write-host "Cannot Reach $computer" -f Cyan}
 
 
 
else {
 
Test-Connection -ComputerName $computer -Count 1
}
} 
