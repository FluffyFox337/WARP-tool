@echo off
set "/dp=%~dp0"
set "/wg=C:\Program Files\WireGuard"
:: set "name_exe_wg_installer=wireguard-amd64-0.5.3.msi"
set "name_exe_wg=wireguard.exe"
set "name_script_obtain=wg_block_obtain.ps1"
set "name_script_start_WG=start_wg.bat"

powershell.exe -noprofile -executionpolicy bypass -file %name_script_obtain%
start "" %/wg%%name_exe_wg%"
exit"
