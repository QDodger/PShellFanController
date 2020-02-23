$hostip = "IP"
$user = "root"
$pass = "pass"

$max = 38
$cooldown = 32

$ctemp = ipmitool -I lanplus -H $hostip -U $user -P $pass sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1
#Write-host "Current temp ="$ctemp

while($true)
{
    $ctemp = ipmitool -I lanplus -H $hostip -U $user -P $pass sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1
    #$ctemp = 37
    Write-Host "Server Temperature is currently $ctemp"
    if ($ctemp -gt $max)
    {Write-host "Server temperature too high, switching to dynamic fan control."
        ipmitool -I lanplus -H $hostip -U $user -P $pass raw 0x30 0x30 0x01 0x01
        $mode = 1}
        
        if ($mode -eq 1)
        {Write-Host "Fans are in Auto, checking temp"
            if ($ctemp -lt $cooldown)
        {Write-Host "Temp has returned to normal, re-activitng silent fans"
            ipmitool -I lanplus -H $hostip -U $user -P $pass raw 0x30 0x30 0x01 0x00
            ipmitool -I lanplus -H $hostip -U $user -P $pass raw 0x30 0x30 0x02 0xff 0x09
            $mode = 0
        }
        else {Write-Host "Current temp is still above normal"}}
        Start-Sleep 4
}
