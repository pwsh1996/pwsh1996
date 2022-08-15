########################
#   Customize Prompt   #
########################
function prompt { #Colors the Prompt
    Write-Host "ʝąζöʙ ϷϵͲɼίέ " -ForegroundColor Green -NoNewline
        $battremaining = (Get-WmiObject win32_battery).estimatedchargeremaining
        if ($battremaining -gt 66) { Write-Host "🔋$battremaining% " -ForegroundColor DarkGreen -NoNewline }
        elseif ($battremaining -lt 33) { Write-Host "🔋$battremaining% " -ForegroundColor DarkRed -NoNewline }
        else { Write-Host "🔋$battremaining% " -ForegroundColor DarkYellow -NoNewline }
    # Write-Host $pwd -ForegroundColor DarkGreen -NoNewline
    "> "
  }

##################
#  Set Defaults  #
##################
$PSDefaultParameterValues["Get-ADUser:Properties"] = "PasswordLastSet"

#############################
#   Customize PS ReadLine   #
#############################
set-PSReadLineOption -PredictionSource History
# Needs to be version 2.2.2 to have the PredictionViewStyle option
set-psReadLineOption -PredictionViewStyle ListView



###########################################################################
# To Use:
# notepad.exe $profile
# And paste the contents in, then save, you will need to restart PowerSehll
#
# If you run into problems adding it you may need to just check $profile
# And make sure there is a path to where it is point, if not, create it
#
# You should also change the shortcut you're using to point to PowerShell
# With the flag
# -nologo 
#
