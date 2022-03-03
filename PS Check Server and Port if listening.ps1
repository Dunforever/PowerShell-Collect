$targetServer= Read-Host "Enter ServerName to Check Port"

$targetPort= Read-Host "Enter Port to check if Listening"

echo ((new-object Net.Sockets.TcpClient).Connect($targetServer,$targetPort)) "$targetPort is

open on $targetServer."