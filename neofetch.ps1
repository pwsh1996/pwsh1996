############################################
#  Custom Version of dylanaraps/neofetch   #
#   to make it run faster on Windows and   # 
#   have no dependencies on Scoop and GIT  #
# by Jacob Petrie                          #
############################################

$hostinfo = (Get-WMIObject -ClassName Win32_ComputerSystem)
$username = ($hostinfo.Username).Split('\')[1]
$hostname = hostname
$hostmodel = $hostinfo.SystemFamily
$shelly = "Powershell " + $PSVersionTable.PSVersion
$cpuinfo = (((Get-WmiObject Win32_Processor).Name).replace('(R)',"")).replace('(TM)',"")
$meminfo = (Get-WmiObject win32_physicalmemory).capacity / 1024 /1024
$consoleorvs = $host.name
$osver = "$(((Get-WMIObject win32_operatingsystem).name).split("|")[0]) $((Get-WmiObject Win32_OperatingSystem).OSArchitecture)"

###############################
#  Version Specific commands  # 
###############################
if ($PSVersionTable.PSVersion.major -ge 6){
    $kernelver = ($PSVersionTable.OS).Split(" ")[2]
    $uptime = get-uptime
}
else {
    $kernelver = ($PSVersionTable.BuildVersion).tostring()
    $uptime = (get-date) - (gcim Win32_OperatingSystem).LastBootUpTime
}

#############################
#  Gets the Terminal data  #
#############################
if ($consoleorvs -eq "ConsoleHost") {
    $parenthoster = (Get-Process -id $pid).parent.ProcessName
    if ($parenthoster -eq "WindowsTerminal") {
        $terminfo = "Windows Terminal"
    }
    else {
        $terminfo = "Console Host"
    }
}
else {
    $terminfo = $host.name
}

######################
#  Gets the Uptime  #
######################
$dayss = $uptime.days.tostring()
$hourss = $uptime.hours.tostring()
$minutess = $uptime.minutes.tostring()

if ($dayss -eq "1") {
    $dayss = "1 day,"
}
elseif ($dayss -eq "0") {
    $dayss = ""
}
else {
    $dayss = "$dayss days,"
}

if ($hourss -eq "1") {
    $hourss = "1 hour,"
}
elseif ($hourss -eq "0") {
    $hourss = ""
}
else {
    $hourss = "$hourss hours,"
}

if ($minutess -eq "1") {
    $minutess = "1 minute"
}
elseif ($minutess -eq "0") {
    $minutess = ""
}
else {
    $minutess = "$minutess minutes"
}

$uptimeout = "$dayss$hourss$minutess"

#######################
#  Writes the output  #
#######################
clear-host
Write-Host '        ,.=:!!t3Z3z.,' -ForegroundColor red -NoNewline; write-host "                 $username" -ForegroundColor Red -NoNewline;write-host "@" -NoNewline; write-host "$hostname" -ForegroundColor Red
Write-Host '       :tt:::tt333EE3' -ForegroundColor Red -NoNewline; Write-Host '                 ------------------------'
write-host '       Et:::ztt33EEEL' -ForegroundColor Red -NoNewline; Write-Host ' @Ee.,      ..,' -ForegroundColor Green -NoNewline; Write-Host "  OS" -ForegroundColor Green -NoNewline; Write-Host ": $osver"
Write-Host '      ;tt:::tt333EE7' -ForegroundColor Red -NoNewline; Write-Host ' ;EEEEEEttttt33#' -ForegroundColor Green -NoNewline; Write-Host "  Host" -ForegroundColor Green -NoNewline; Write-Host ": $hostmodel"
Write-Host '     :Et:::zt333EEQ.' -ForegroundColor Red -NoNewline; Write-Host ' $EEEEEttttt33QL' -ForegroundColor Green -NoNewline; Write-Host "  Kernel" -ForegroundColor Green -NoNewline; Write-Host ": $kernelver"
Write-Host '     it::::tt333EEF' -ForegroundColor Red -NoNewline; Write-Host ' @EEEEEEttttt33F' -ForegroundColor Green -NoNewline; Write-Host "   Uptime" -ForegroundColor Green -NoNewline; Write-Host ": $uptimeout"
write-host '    ;3=*^```"*4EEV' -ForegroundColor Red -NoNewline; write-host ' :EEEEEEttttt33@.' -ForegroundColor Green -NoNewline; Write-Host "   Shell" -ForegroundColor Green -NoNewline; Write-Host ": $shelly"
Write-Host '    ,.=::::!t=., ' -ForegroundColor Blue -NoNewline; Write-Host '`' -ForegroundColor Red -NoNewline; Write-Host ' @EEEEEEtttz33QF' -ForegroundColor Green -NoNewline; Write-Host "    Resolution" -ForegroundColor Green -NoNewline; Write-Host ': '
write-host '   ;::::::::zt33)' -ForegroundColor Blue -NoNewline; write-host '   "4EEEtttji3P*' -ForegroundColor Green -NoNewline; Write-Host "     DE" -ForegroundColor Green -NoNewline; Write-Host ': '
write-host '  :t::::::::tt33.' -ForegroundColor Blue -NoNewline; write-host ':Z3z..' -ForegroundColor Yellow -NoNewline; write-host '  ``' -ForegroundColor Green -NoNewline; Write-Host ' ,..g.' -ForegroundColor Yellow -NoNewline; Write-Host "     WM" -ForegroundColor Green -NoNewline; Write-Host ': '
write-host '  i::::::::zt33F' -ForegroundColor Blue -NoNewline; write-host ' AEEEtttt::::ztF' -ForegroundColor Yellow -NoNewline; Write-Host "      WM Theme" -ForegroundColor Green -NoNewline; Write-Host ': '
write-host ' ;:::::::::t33V' -ForegroundColor Blue -NoNewline; write-host ' ;EEEttttt::::t3' -ForegroundColor Yellow -NoNewline; Write-Host "       Terminal" -ForegroundColor Green -NoNewline; Write-Host ": $terminfo"
write-host ' E::::::::zt33L' -ForegroundColor Blue -NoNewline; Write-Host ' @EEEtttt::::z3F' -ForegroundColor Yellow -NoNewline; Write-Host "       CPU" -ForegroundColor Green -NoNewline; Write-Host ": $cpuinfo"
write-host '{3=*^```"*4E3)' -ForegroundColor Blue -NoNewline; write-host ' ;EEEtttt:::::tZ`' -ForegroundColor Yellow -NoNewline; Write-Host "       Memory" -ForegroundColor Green -NoNewline; Write-Host ": $meminfo"
Write-Host '             `' -ForegroundColor Blue -NoNewline; Write-Host ' :EEEEtttt::::z7' -ForegroundColor Yellow
write-host '                 "VEzjt:;;z>*`        ' -ForegroundColor Yellow -NoNewline
write-host "   " -BackgroundColor Black -NoNewline
write-host "   " -BackgroundColor darkRed -NoNewline
write-host "   " -BackgroundColor darkGreen -NoNewline
write-host "   " -BackgroundColor DarkYellow -NoNewline
write-host "   " -BackgroundColor darkBlue -NoNewline
write-host "   " -BackgroundColor DarkMagenta -NoNewline
write-host "   " -BackgroundColor DarkCyan -NoNewline
write-host "   " -BackgroundColor Gray
Write-Host '                                      ' -NoNewline
write-host "   " -BackgroundColor DarkGray -NoNewline
write-host "   " -BackgroundColor red -NoNewline
write-host "   " -BackgroundColor Green -NoNewline
write-host "   " -BackgroundColor Yellow -NoNewline
write-host "   " -BackgroundColor Blue -NoNewline
write-host "   " -BackgroundColor Magenta -NoNewline
write-host "   " -BackgroundColor Cyan -NoNewline
write-host "   " -BackgroundColor White
