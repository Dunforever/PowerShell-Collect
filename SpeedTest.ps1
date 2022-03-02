#https://www.speedtest.net/apps/cli
cls

$DownloadURL = "https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-win64.zip"
#location to save on the computer. Path must exist or it will error
$DOwnloadPath = "c:\temp\SpeedTest.Zip"
$ExtractToPath = "c:\temp\SpeedTest"
$SpeedTestEXEPath = "C:\temp\SpeedTest\speedtest.exe"
#Log File Path
$LogPath = 'c:\temp\SpeedTestLog.txt'

#Start Logging to a Text File
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $LogPath -Append:$false
#check for and delete existing log files

function RunTest()
{
    $test = & $SpeedTestEXEPath --accept-license
    $test
}

function sendMail ($subject, $message)
{
    "Sending Email"

    #SMTP server name
    $smtpServer = "smtp.office365.com"
    $EmailSender = "jon.boyette@salelytics.com"
    $emailPassword = ""
    $port = '587'
    $from = ""
    $to = "jon.boyette@salelytics.com"

    #Creating a Mail object
    $msg = new-object Net.Mail.MailMessage
    
    $emailCredential = New-Object System.Net.NetworkCredential($EmailSender, $emailPassword)

    #Creating SMTP server object
    $smtp = new-object Net.Mail.SmtpClient($smtpServer)
    $smtp.Port = $port
    
    $smtp.EnableSSl = $true
    $smtp.Credentials = $emailCredential

    #Email structure
    $msg.From = $from
    $msg.To.add($to)
    $msg.subject = $subject
    $msg.body = $message 

    #Sending email
    $smtp.Send($msg)

    write-host "Email Sent" -ForegroundColor Green

};

#check if file exists
if (Test-Path $SpeedTestEXEPath -PathType leaf)
{
    Write-Host "SpeedTest EXE Exists, starting test" -ForegroundColor Green
    RunTest
}
else
{
    Write-Host "SpeedTest EXE Doesn't Exist, starting file download"

    #downloads the file from the URL
    wget $DownloadURL -outfile $DOwnloadPath

    #Unzip the file
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    function Unzip
    {
        param([string]$zipfile, [string]$outpath)

        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    }

    Unzip $DOwnloadPath $ExtractToPath
    RunTest
}


#get hostname
$Hostname = hostname

#read results out of log file into string
$MailMessage = (Get-Content -Path $LogPath) -join "`n"

#email results use log file string as body
$MailSubject = $Hostname + " SpeedTest Results"
sendMail $MailSubject $MailMessage

#stop logging
Stop-Transcript
exit 0
