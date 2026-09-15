@echo off
REM ============================================================================
REM   Dev_Fahim_Code
REM   https://github.com/dev-fahim-code
REM   Full RAM Information Tool
REM ============================================================================

title Dev_Fahim_Code - RAM Information Tool

REM ---- Relaunch elevated (as Administrator) if not already elevated ----
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Requesting administrator privileges, please click "Yes" on the prompt...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

REM ---- Set console colors: black background / light red foreground ----
color 0C
cls

echo ================================================================================
echo.
echo                                 Dev_Fahim_Code
powershell -NoProfile -Command "Write-Host '                       https://github.com/dev-fahim-code' -ForegroundColor Blue"
echo.
echo ================================================================================
echo.
echo                           FULL RAM INFORMATION REPORT
echo ================================================================================
echo.

REM ---- Build a temporary PowerShell script to gather full RAM details ----
set "PSFILE=%temp%\dfc_raminfo_%RANDOM%.ps1"

> "%PSFILE%" echo Write-Host "[ RAM SUMMARY ]"
>>"%PSFILE%" echo Write-Host "--------------------------------------------------------------------------------"
>>"%PSFILE%" echo $os = Get-WmiObject Win32_OperatingSystem
>>"%PSFILE%" echo $cs = Get-WmiObject Win32_ComputerSystem
>>"%PSFILE%" echo $installedGB = [math]::Round($cs.TotalPhysicalMemory/1GB,2)
>>"%PSFILE%" echo $totalGB = [math]::Round($os.TotalVisibleMemorySize/1MB,2)
>>"%PSFILE%" echo $freeGB  = [math]::Round($os.FreePhysicalMemory/1MB,2)
>>"%PSFILE%" echo $usedGB  = [math]::Round($totalGB-$freeGB,2)
>>"%PSFILE%" echo Write-Host ("Installed Physical RAM : {0} GB" -f $installedGB)
>>"%PSFILE%" echo Write-Host ("Usable RAM             : {0} GB" -f $totalGB)
>>"%PSFILE%" echo Write-Host ("Used RAM               : {0} GB" -f $usedGB)
>>"%PSFILE%" echo Write-Host ("Free RAM               : {0} GB" -f $freeGB)
>>"%PSFILE%" echo Write-Host ""
>>"%PSFILE%" echo Write-Host "[ RAM MODULE DETAILS ]"
>>"%PSFILE%" echo Write-Host "--------------------------------------------------------------------------------"
>>"%PSFILE%" echo Write-Host "(Note: CAS Latency lives on each module's SPD chip and is not exposed by Windows/WMI - check CPU-Z if you need it.)"
>>"%PSFILE%" echo Write-Host ""
>>"%PSFILE%" echo $modules = Get-WmiObject Win32_PhysicalMemory
>>"%PSFILE%" echo $i = 0
>>"%PSFILE%" echo $pinUDIMM = @{ "DDR"="184-pin"; "DDR2"="240-pin"; "DDR3"="240-pin"; "DDR4"="288-pin"; "DDR5"="288-pin" }
>>"%PSFILE%" echo $pinSODIMM = @{ "DDR"="200-pin"; "DDR2"="200-pin"; "DDR3"="204-pin"; "DDR4"="260-pin"; "DDR5"="262-pin" }
>>"%PSFILE%" echo $memType = @{ 0="Unknown"; 1="Other"; 2="DRAM"; 3="Synchronous DRAM"; 4="Cache DRAM"; 5="EDO"; 6="EDRAM"; 7="VRAM"; 8="SRAM"; 9="RAM"; 10="ROM"; 11="Flash"; 12="EEPROM"; 13="FEPROM"; 14="EPROM"; 15="CDRAM"; 16="3DRAM"; 17="SDRAM"; 18="SGRAM"; 19="RDRAM"; 20="DDR"; 21="DDR2"; 22="DDR2 FB-DIMM"; 23="Reserved"; 24="DDR3"; 25="FBD2"; 26="DDR4"; 27="LPDDR"; 28="LPDDR2"; 29="LPDDR3"; 30="LPDDR4"; 31="Logical Non-Volatile"; 32="HBM"; 33="HBM2"; 34="DDR5"; 35="LPDDR5"; 36="HBM3" }
>>"%PSFILE%" echo foreach ($m in $modules) {
>>"%PSFILE%" echo $i++
>>"%PSFILE%" echo $capGB = [math]::Round($m.Capacity/1GB,2)
>>"%PSFILE%" echo $type = switch ($m.SMBIOSMemoryType) { 20 {"DDR"} 21 {"DDR2"} 24 {"DDR3"} 26 {"DDR4"} 34 {"DDR5"} default {"Unknown"} }
>>"%PSFILE%" echo $ff = switch ($m.FormFactor) { 8 {"DIMM"} 12 {"SODIMM"} default {"Other"} }
>>"%PSFILE%" echo if ($ff -eq "SODIMM") { $pins = $pinSODIMM[$type] } else { $pins = $pinUDIMM[$type] }
>>"%PSFILE%" echo if (-not $pins) { $pins = "Unknown" }
>>"%PSFILE%" echo $voltRaw = $m.ConfiguredVoltage
>>"%PSFILE%" echo if ($voltRaw -and $voltRaw -gt 0) { $volt = "{0:N2} V" -f ($voltRaw/1000) } else { $volt = "Not reported by BIOS" }
>>"%PSFILE%" echo Write-Host ("Module #{0}" -f $i)
>>"%PSFILE%" echo Write-Host ("  Slot            : {0}" -f $m.DeviceLocator)
>>"%PSFILE%" echo Write-Host ("  Bank            : {0}" -f $m.BankLabel)
>>"%PSFILE%" echo Write-Host ("  Capacity        : {0} GB" -f $capGB)
>>"%PSFILE%" echo Write-Host ("  Rated Speed     : {0} MHz" -f $m.Speed)
>>"%PSFILE%" echo Write-Host ("  Running Speed   : {0} MHz" -f $m.ConfiguredClockSpeed)
>>"%PSFILE%" echo Write-Host ("  Manufacturer    : {0}" -f $m.Manufacturer)
>>"%PSFILE%" echo Write-Host ("  Part Number     : {0}" -f $m.PartNumber)
>>"%PSFILE%" echo Write-Host ("  Serial Number   : {0}" -f $m.SerialNumber)
>>"%PSFILE%" echo Write-Host ("  Memory Type     : {0}" -f $type)
>>"%PSFILE%" echo Write-Host ("  Form Factor     : {0}" -f $ff)
>>"%PSFILE%" echo Write-Host ("  Pin Count       : {0}" -f $pins)
>>"%PSFILE%" echo Write-Host ("  Operating Volt. : {0}" -f $volt)
>>"%PSFILE%" echo Write-Host ""
>>"%PSFILE%" echo }
>>"%PSFILE%" echo Write-Host "[ SLOT USAGE ]"
>>"%PSFILE%" echo Write-Host "--------------------------------------------------------------------------------"
>>"%PSFILE%" echo $arr = Get-WmiObject Win32_PhysicalMemoryArray
>>"%PSFILE%" echo Write-Host ("Total Memory Slots      : {0}" -f $arr.MemoryDevices)
>>"%PSFILE%" echo Write-Host ("Slots Used              : {0}" -f $modules.Count)
>>"%PSFILE%" echo Write-Host ("Slots Free              : {0}" -f ($arr.MemoryDevices - $modules.Count))

powershell -NoProfile -ExecutionPolicy Bypass -File "%PSFILE%"

del "%PSFILE%" >nul 2>&1

echo.
echo ================================================================================
echo   Report generated by Dev_Fahim_Code
echo   https://github.com/dev-fahim-code
echo ================================================================================
echo.
pause
