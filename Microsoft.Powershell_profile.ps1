# Verse of the day from Bible.com
$verse = @(((wget https://www.bible.com/verse-of-the-day).content | where {$_ -match 'data-param-text='}).tostring().split('="') | where {$_ -match '[123]? \w+ \d+\:\d+-?\d*\: \w'})
Write-Host $verse[0] -ForegroundColor Black -BackgroundColor white
