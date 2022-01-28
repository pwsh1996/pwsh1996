#
# VERSE OF THE DAY BANNER
#
$verse = @(((wget https://www.bible.com/verse-of-the-day).content | where {$_ -match 'data-param-text='}).tostring().split('="') | where {$_ -match '[123]? ?\w+ \d+\:\d+-?\d*\: \w'})
Write-Host $verse[0] -ForegroundColor Black -BackgroundColor white
#
# FUNCTIONS
#
function clearhostverse {
clear-host
Write-Host $verse[0] -ForegroundColor Black -BackgroundColor white
}
#
# ALIASES
#
set-alias -name CLS -Value clearhostverse -Option AllScope # clears the screen and pastes the verse of the day at the top again


###########################################################################
# To Use:
# In Windows PowerShell (not compatible with PowerShell Core) run
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
