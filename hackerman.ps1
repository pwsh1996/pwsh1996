write-host "----------------------------------------"
write-host '    |_| |\  /` |/ [ |) |\/| |\  |\ |'
write-host '    | | |`\ \_ |\ [ |\ |  | |`\ | \|'
write-host "----------------------------------------"
write-host "Warning: this will modify your registry" -ForegroundColor DarkRed
write-host ""
write-host "Available NICs:" -ForegroundColor DarkGray
write-host ""
#Get a copy of the NICs from the registry
$regnics = get-childitem Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\"{4d36e972-e325-11ce-bfc1-08002be10318}" -ErrorAction Ignore

$realnics = Get-NetAdapter
$number = 1
foreach ($realnic in $realnics) {
    write-host " $number  $($realnic.name)"
    $number++
}
write-host ""
[ValidatePattern('^\d')]$nicselection = read-host "Select the NIC you'd like to use"
Write-Host ""
write-host "----------------------------------------"
$nic = $realnics[$nicselection - 1]

# 
# Do a dummy check to make sure the property NetworkAddress exists
#

$formatedmac = $nic.macaddress -replace "-", ""

foreach ($regnic in $regnics) {
    if ($(Get-ItemProperty Registry::$regnic).driverdesc -eq $nic.InterfaceDescription) {
        $noobcheck = (get-itemproperty Registry::$regnic) | where-object { $_ -match "NetworkAddress" }
        if ($null -eq $noobcheck) {
            $a = New-ItemProperty -Path Registry::$regnic -Name NetworkAddress -PropertyType String -Value $formatedmac
            $regmac = $a.NetworkAddress
        }
        else {
            $regmac = (get-itemproperty Registry::$regnic).NetworkAddress
        }
    }
}

#
# Drop some interface stats
#
write-host "$($nic.name)" -NoNewline
write-host "  $($nic.interfaceDescription)" -ForegroundColor DarkGray
write-host "----------------------------------------"
if ($nic.status -eq "Up") {
    write-host "Status:" -ForegroundColor DarkGray -NoNewline
    write-host " Up" -ForegroundColor Green
}
else {
    write-host "Status:" -ForegroundColor DarkGray -NoNewline
    write-host " Disconnected" -ForegroundColor Red
}
write-host "MacAddress:" -ForegroundColor DarkGray -NoNewline
write-host " $regmac" -ForegroundColor White
write-host "IPAddress:" -ForegroundColor DarkGray -NoNewline
$nicipaddr = $($nic | get-netipaddress -addressfamily ipv4).ipaddress
write-host " $nicipaddr" -ForegroundColor White
write-host ""
