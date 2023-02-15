# Listening on port 443
$listener = [System.Net.Sockets.TcpListener]443; $listener.Start();
 
while($true)
{
    $client = $listener.AcceptTcpClient();
    Write-Host $client.client.RemoteEndPoint "Connected";
    $client.Close();
    start-sleep -seconds 1;
}
