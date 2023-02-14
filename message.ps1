$name = Read-Host "Machine name"
$msg = Read-Host "Message"

Invoke-Command -ScriptBlock {msg.exe * "$msg"} -ComputerName $name