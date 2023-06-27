######################
#   Colors Strings   #
######################
function color-string {
    param (
        [string]$string = ""
    )
    if ($string.length -le 4) {
        Write-Host $string -ForegroundColor darkgreen
    }
    else {
        $random = Get-Random -Minimum 1 -Maximum 5

        if ($random -eq 1) {
            for ($i = 0; $i -le $($string.Length - 1) ; $i++) {
                $b = $i * ([math]::round(255 / $($($string.length))) - 1)
                Write-Host "$($PSStyle.Foreground.FromRgb(44,200,$b))$($string[$i])$($PSStyle.Reset)" -NoNewline
            }
        }
        elseif ($random -eq 2) {
            for ($i = 0; $i -le $($string.Length - 1) ; $i++) {
                $b = $i * ([math]::round(255 / $($($string.length))) - 1)
                Write-Host "$($PSStyle.Foreground.FromRgb(200,22,$b))$($string[$i])$($PSStyle.Reset)" -NoNewline
            }
        }
        elseif ($random -eq 3) {
            for ($i = 0; $i -le $($string.Length - 1) ; $i++) {
                $b = $i * ([math]::round(255 / $($($string.length))) - 1)
                Write-Host "$($PSStyle.Foreground.FromRgb(20,$b,200))$($string[$i])$($PSStyle.Reset)" -NoNewline 
            }
        }
        elseif ($random -eq 4) {
            for ($i = 0; $i -le $($string.Length - 1) ; $i++) {
                $b = $i * ([math]::round(255 / $($($string.length))) - 1)
                Write-Host "$($PSStyle.Foreground.FromRgb($b,50,200))$($string[$i])$($PSStyle.Reset)" -NoNewline 
            }
        }

        Write-Host ""
    }
}


########################
#   Customize Prompt   #
########################
function prompt {
if ($(get-history).count -ge 1){
    if ( $(((get-history)[(get-history).count -1].commandline) | ? {$_ -match "[a-z]+-[a-z]+"}) -ne $null){
 foreach ($alias in get-alias){
 if ( $(((get-history)[(get-history).count -1].commandline) | ? {$_ -match $alias.definition}) -ne $null){
 write-host "Tip: try alias " -ForegroundColor Gray -BackgroundColor DarkYellow -NoNewline
 write-host "$($alias.name)" -ForegroundColor Cyan -BackgroundColor DarkYellow -NoNewline
 write-host " instead of " -ForegroundColor gray -BackgroundColor DarkYellow -NoNewline
 write-host "$($alias.Definition)" -ForegroundColor Cyan -BackgroundColor DarkYellow}
 }
 }
}
    
    #Colors the Prompt
    write-host "╭─" -NoNewline

    $battremaining = (Get-WmiObject win32_battery).estimatedchargeremaining
    if ($battremaining -gt 66) { Write-Host "🔋$battremaining% " -ForegroundColor DarkGreen -NoNewline }
    elseif ($battremaining -lt 33) { Write-Host "🔋$battremaining% " -ForegroundColor DarkRed -NoNewline }
    else { Write-Host "🔋$battremaining% " -ForegroundColor DarkYellow -NoNewline }
    
    Write-Host "─ " -NoNewline

if ($(get-history).count -ge 1){
$time = (get-history)[(get-history).count -1].Duration

if ($time.Days -eq 0){
    if ($time.Hours -eq 0){
        if ($time.Minutes -eq 0) {
            if ($time.Seconds -eq 0){
                write-host "$($time.Milliseconds)ms ─ " -nonewline
            }
            else {
                write-host "$($time.Seconds)s ─ " -nonewline
            }
        }
        else {
            write-host "$($time.Minutes)mins ─ " -nonewline
        }
    }
    else {
        write-host "$($time.Hours)hours ─ " -nonewline
    }
}
else {
    write-host "$($time.Days)days ─ " -nonewline
}

}
    color-string $pwd

    "╰─> "
}

##################
#  Set Defaults  #
##################
$PSDefaultParameterValues["Get-ADUser:Properties"] = "PasswordLastSet"
$PSDefaultParameterValues["Select-String:Path"] = "*"

#############################
#   Customize PS ReadLine   #
#############################
set-PSReadLineOption -PredictionSource History
# Needs to be version 2.2.2 to have the PredictionViewStyle option
set-psReadLineOption -PredictionViewStyle ListView
