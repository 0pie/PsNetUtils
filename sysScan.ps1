cls

$input = Read-Host "System Statistics Utility :
[1] - Single machine statistics
[2] - Statistics for all machines on the network

Selection"

if ($input -eq 1){
        $pc = Read-Host "Name/IP of the machine"
        $os = gwmi -Class win32_operatingSystem -ComputerName $pc
        $diff = $os.ConvertToDateTime($os.LocalDateTime) - $os.ConvertToDateTime($os.LastBootUpTime)
        $ram = (($os.TotalVisibleMemorySize - $os.FreePhysicalMemory)/1024/1024)
        $cpu = gwmi -Class win32_processor | Select LoadPercentage
        $sys = gwmi win32_computersystem -ComputerName $pc
        $ware = gwmi win32_logicaldisk -ComputerName $pc

        $properties=[ordered]@{
          'Machine'=$sys.name
          'Model'=$sys.model
          'Operating time (Day)'=$diff.Days
          'Operating time (Hours)'=$diff.Hours
          'Operating time (Minutes)'=$diff.Minutes
          'RAM Usage (Gb)'=$ram
          'CPU Usage (%)'=$cpu.LoadPercentage
          'Free disk space (Gb)'=($ware.FreeSpace)/[Math]::Pow(1024,3) # divide by 1024^3 (byte->Gb)
          'Total disk space (Gb)'=($ware.Size)/[Math]::Pow(1024,3)
          #'Connected user'=$sys.username.split("\")[1]
        }
        $obj = New-Object -TypeName PSObject -Property $properties

        Write-Output $obj # display the object
        exit
          
}
if ($input -eq 2){
    $req=Get-NetTCPConnection | WHERE state -notlike "Listen"| WHERE RemoteAddress -notlike ::1 | WHERE RemoteAddress -notlike 127.0.0.1 | select RemoteAddress # we ignore TCP Listens and loopbacks

    foreach($line in $req.RemoteAddress) {
        $os = gwmi -Class win32_operatingSystem -ComputerName $line
        $diff = $os.ConvertToDateTime($os.LocalDateTime) - $os.ConvertToDateTime($os.LastBootUpTime)
        $ram = (($os.TotalVisibleMemorySize - $os.FreePhysicalMemory)/1024/1024)
        $cpu = gwmi -Class win32_processor | Select LoadPercentage
        $sys = gwmi win32_computersystem -ComputerName $line
        $ware = gwmi win32_logicaldisk -ComputerName $line | WHERE DeviceID -like "C:"

        $properties=[ordered]@{
          'Machine'=$sys.name
          'Model'=$sys.model
          'Operating time (Day)'=$diff.Days
          'Operating time (Hours)'=$diff.Hours
          'Operating time (Minutes)'=$diff.Minutes
          'RAM Usage (Gb)'=$ram
          'CPU Usage (%)'=$cpu.LoadPercentage
          'Free disk space (Gb)'=($ware.FreeSpace)/[Math]::Pow(1024,3) # divide by 1024^3 (byte->Gb)
          'Total disk space (Gb)'=($ware.Size)/[Math]::Pow(1024,3)
          #'Connected user'=$sys.username.split("\")[1]
        }
        $obj = New-Object -TypeName PSObject -Property $properties

        echo "================================================================="
        Write-Output $obj
    }
    exit

} else { echo "Error please select one of the following: 1 or 2"}
