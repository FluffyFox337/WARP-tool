$wgListenPort = Get-Content wgListenPort.txt
$wgIP = Get-Content wgIP.txt
$wgPORT = Get-Content wgPORT.txt

$wgListenPort
$wgIP
$wgPORT

$EndPoints = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Parse([System.Net.Dns]::GetHostAddresses($wgIP)), $wgPORT) 
$Socket = New-Object System.Net.Sockets.UDPClient $wgListenPort
$SendMessage = $Socket.Send([Text.Encoding]::ASCII.GetBytes(":)"), 2, $EndPoints) 
$Socket.Close()
Start-Process -FilePath "wireguard.exe" -WorkingDirectory "C:\Program Files\WireGuard"
exit
