@ECHO OFF


   :: ===== File info =====
   :: encoding UTF-8
   :: syntaxis Batch CMD BAT
   :: last edit:14.10.24 / 17:30 msk
   :: =====================
   
 :: cd c:\wgcf
 
:: ========================== NOTE =====================================================
::          Direct names:
:: wgListenPort.txt
:: wgPORT.txt
:: wgIP.txt
   
:: Start-Process -FilePath "wireguard.exe" -WorkingDirectory "C:\Program Files\WireGuard"

:: Taskkill /f /im %name_exe_wg_process%

:: https://api.cloudflareclient.com
:: https://cloudflare.com/cdn-cgi/trace

:: engage.cloudflareclient.com

:: https://github.com/ViRb3/wgcf

:: ========================== Pathes ===================================================
set "/dp=%~dp0"

set "/wg=C:\Program Files\WireGuard"
set "/wg_cfg=%/wg%\Data\Configurations"

:: ========================== Names ====================================================
set "name_exe_wgcf=wgcf.exe"

set "name_exe_wg_installer_32=wireguard-x86-0.5.3.msi"
set "name_exe_wg_installer_64=wireguard-amd64-0.5.3.msi"
set "name_exe_wg_process=wireguard.exe"

set "name_conf_start=delete-it-after-generate-new-conf.conf"

set "name_conf_wgcf-profile=wgcf-profile.conf"
set "name_conf_wgcf-account=wgcf-account.toml"

set "name_script_obtain=wg_block_obtain.ps1"
set "name_script_start_WG=start_wg.bat"

:: WARNING direct names exists! (wg_block_obtain.ps1)
set "name_txt_ListenPort=wgListenPort.txt"
set "name_txt_wgPORT=wgPORT.txt"
set "name_txt_wgIP=wgIP.txt"


:: ========================== URL ========================================================
set "url_WG=https://github.com/FluffyFox337/WireGuard/raw/main/wireguard-amd64-0.5.3.msi"

set "url_wgcf=https://github.com/FluffyFox337/WireGuard/raw/main/wireguard-amd64-0.5.3.msi"


set "url_start_conf=https://raw.githubusercontent.com/FluffyFox337/WARP-tool/refs/heads/main/assets/profiles-conf/delete-it-after-generate-new-conf.conf"

set "url_script_obtain=https://raw.githubusercontent.com/FluffyFox337/WireGuard/refs/heads/main/wg_block_obtain.ps1"
set "url_script_start_wg=https://raw.githubusercontent.com/FluffyFox337/WireGuard/refs/heads/main/start_wg.bat"


:start1
:: ========================== reset VARS ==================================================
call :reset_vars
:: ========================== folders conditions ==========================================
if exist "%/dp%%name_conf_wgcf-profile%" del "%/dp%%name_conf_wgcf-profile%" >nul 2>&1

if not exist "%/dp%%name_exe_wgcf%" rename *.exe %name_exe_wgcf%
if not exist "%/dp%%name_exe_wgcf%" goto wgcf_not_exist

if not exist "%/wg%" call :download_wg


if exist "%/dp%%name_txt_ListenPort%" goto cnt0
set first_start=1
echo ===========================================
echo     enter listen port for obtain script
echo ===========================================
echo Enter about 50000 to 60000.
echo          Example: 55685
set /p wgListenPort_num= Enter ListenPort: 
call :set_wglistenport %wgListenPort_num%
call :write_wglistenport

:cnt0
if not exist "%/dp%%name_txt_wgIP%" (
echo ===========================================
echo            choice endpoint IP
echo ===========================================
echo [1] 162.159.193.1
echo [2] 162.159.193.2
echo [3] 162.159.193.3
echo [4] 162.159.193.4
echo [5] 162.159.193.5
echo [6] 162.159.193.6
echo [7] 162.159.193.7
echo [8] 162.159.193.8
echo -------------------------------------------
echo [9] exit.
choice /c 123456789 /n
 if errorlevel 9 goto exit
 if errorlevel 8 (
 call :set_wgIP 162.159.193.8
 goto cnt01 )
 if errorlevel 7 (
 call :set_wgIP 162.159.193.7
 goto cnt01 )
 if errorlevel 6 (
 call :set_wgIP 162.159.193.6
 goto cnt01 )
 if errorlevel 5 (
 call :set_wgIP 162.159.193.5
 goto cnt01 )
 if errorlevel 4 (
 call :set_wgIP 162.159.193.4
 goto cnt01 )
 if errorlevel 3 (
 call :set_wgIP 162.159.193.3
 goto cnt01 )
 if errorlevel 2 (
 call :set_wgIP 162.159.193.2
 goto cnt01 )
 if errorlevel 1 (
 call :set_wgIP 162.159.193.1
 goto cnt01 )
:cnt01
call :write_wgip )

if not exist "%/dp%%name_txt_wgPORT%" (
echo ===========================================
echo            choice endpoint port
echo ===========================================
echo [1] 500              %wgip%:500
echo [2] 1701             %wgip%:1701
echo [3] 2408             %wgip%:2408
echo [4] 4500             %wgip%:4500
echo -------------------------------------------
echo [5] exit.
choice /c 12345 /n
 if errorlevel 5 goto exit
 if errorlevel 4 (
 call :set_wgport 4500
 goto cnt02 )
 if errorlevel 3 (
 call :set_wgport 2408
 goto cnt02 )
 if errorlevel 2 (
 call :set_wgport 1701
 goto cnt02 )
 if errorlevel 1 (
 call :set_wgport 500
 goto cnt02 )
:cnt02
call :write_wgport )

if "%first_start%"=="0" goto start2
call :download_start_confs
call :read_conf_m
call :read_wgListenPort
call :read_wgIP
call :read_wgport
call :set_endpoint
call :write_conf_m
call :move_start_conf
goto make_scripts

:start2
:: ========================== VPN presence check ==============================================
call :check_vpn
if "%vpn_exist%"=="1" goto cnt12
if exist "%/wg_cfg%\%name_conf_start%"=="0" goto cnt13
call :download_start_confs
call :read_conf_m
call :read_wgListenPort
call :read_wgIP
call :read_wgport
call :set_endpoint
call :write_conf_m
call :move_start_conf
echo ============================================================================================
echo                  %name_conf_start% loaded. 
echo --------------------------------------------------------------------------------------------
echo    Please connect to WARP by temp conf and restart this script for generate yourown conf.
echo ============================================================================================
timeout /t 10
goto make_scripts
:cnt13
echo ============================================================================================
echo                  %name_conf_start% already exist. 
echo --------------------------------------------------------------------------------------------
echo    Please connect to WARP by temp conf and continue here for generate yourown conf...
echo ============================================================================================
call :start_wg_installer
timeout /t 10
exit
:cnt12


:: ========================== register =========================================================
call :register
if not exist "%/dp%%name_conf_wgcf-profile%" (
cls
echo ============================================================================================
echo                            %name_conf_wgcf-profile% doesn't exist. 
echo --------------------------------------------------------------------------------------------
echo     Please remake %name_conf_wgcf-profile%. Make sure you have connecton to the internet.
echo ============================================================================================
echo [1] Retry
echo [2] Exit
choice /c 12 /n
 if errorlevel 2 goto exit
 if errorlevel 1 goto start2 )

:: ========================== read all configurations ==========================================
call :read_conf
call :echo_conf
timeout /t 20
call :read_wgIP
call :read_wgport
call :read_wgListenPort
call :set_endpoint

:: ========================== modify configuration ==========================================
cls
echo ====================================
echo          writing new cfg...
echo ====================================
timeout /t 1 /nobreak >nul
call :write_conf_m
call :echo_conf_m
timeout /t 20

cls
color 20
echo ====================================
echo        new cfg is writed...
echo ====================================
timeout /t 1 /nobreak >nul
color 07
echo  [1] Install %name_conf_wgcf-profile% to WG and start WG.
echo ------------------------------------
echo  [2] exit.
choice /c 12 /n
 if errorlevel 2 goto exit
 if errorlevel 1 (
 call :move_conf_WG
 goto make_scripts )






:vpn_ne
cls
echo                     oops!
echo     Looks like clodflare is not available
echo -----------------------------------------------
echo         please start vpn or check connection... 
echo ===============================================
echo [1] retry.
echo [2] exit.
choice /c 12 /n
 if errorlevel 2 goto exit
 if errorlevel 1 goto start2

:wgcf_not_exist
cls
echo ============================================================================================
echo                                 %name_exe_wgcf% doesn't exist. 
echo --------------------------------------------------------------------------------------------
echo     Please make sure that %name_exe_wgcf% is in the same folder as the %name_bat_main%
echo ============================================================================================
echo [] example: C:\wgcf\%name_exe_wgcf%                    
echo             C:\wgcf\%name_bat_main%
pause
exit





:: ========================== Functions (CALL) ==================================================

:reset_vars
set vpn_exist=0
set wg_exist=0
set first_start=0
set all="[Interface]=" "PrivateKey=" "wgListenPort=" "Address=" "Address2=" "DNS=" "MTU=" "[Peer]=" "PublicKey=" "AllowedIPs=" "AllowedIPs2=" "Endpoint="
exit /b


:read_wgIP
set /p wgIP=< %name_txt_wgIP%
exit /b

:set_wgIP
set wgIP=%1
exit /b

:write_wgip
echo %wgIP% >%name_txt_wgIP%
exit /b


:read_wgport
set /p wgport=< %name_txt_wgPORT%
exit /b

:set_wgport
set wgport=%1
exit /b

:write_wgport
echo %wgport% >%name_txt_wgPORT%
exit /b


:read_wgListenPort
set /p wgListenPort_num=< %name_txt_ListenPort%
exit /b


:set_wglistenport
set wgListenPort_num=%1
set "wgListenPort=ListenPort = %wgListenPort_num%"
exit /b

:write_wglistenport
echo %wgListenPort_num% >%name_txt_ListenPort%
exit /b


:set_endpoint
set "Endpoint=Endpoint = %wgip%:%wgport%"
exit /b

:start_wg_installer
start "" %/dp%%name_exe_wg_installer_64%
exit /b

:start_wg
start "" %/dp%%name_exe_wg_process%
exit /b

:download_wg
powershell -command "& { Invoke-WebRequest -Uri '%url_WG%' -OutFile '%/dp%%name_exe_wg_installer_64%' }" >nul
start "" %/dp%%name_exe_wg_installer_64%
timeout /t 5 /nobreak >nul
Taskkill /f /im %name_exe_wg_process%
exit /b

:download_start_conf
powershell -command "& { Invoke-WebRequest -Uri '%url_start_conf%' -OutFile '%/dp%%name_conf_start%' }" >nul
exit /b

:move_start_conf
move /y "%/dp%%name_conf_start%" "%/wg_cfg%\%name_conf_start%" >nul
exit /b


:check_vpn
ping -n 1 rutracker.org >nul
if errorlevel 1 (
set /a vpn_exist=0
) else (
set /a vpn_exist=1
)
ping -n 1 www.instagram.com >nul
if errorlevel 1 (
set /a vpn_exist=0
) else (
set /a vpn_exist=1
)
exit /b

:register
wgcf register --accept-tos
wgcf generate

del "%/dp%wgcf-account.toml" >nul 2>&1
exit /b

:write_conf_m
(
echo %[Interface]%
echo %PrivateKey%
echo %wgListenPort%
echo %Address%
echo %Address2%
echo %DNS%
echo %MTU%
echo %[Peer]%
echo %PublicKey%
echo %AllowedIPs%
echo %AllowedIPs2%
echo %Endpoint%
)>"%/dp0%%name_conf_wgcf-profile%"
exit /b

:read_conf
    For /f "UseBackQ Tokens=1* Delims=:" %%A IN (`findstr /N /R /C:"." %/dp%%name_conf_wgcf-profile%`) Do set "@@%%A=%%B"
    set All="[Interface]=%@@1%" "PrivateKey=%@@2%" "Address=%@@3%" "Address2=%@@4%" "DNS=%@@5%" "MTU=%@@6%" "[Peer]=%@@7%" "PublicKey=%@@8%" "AllowedIPs=%@@9%" "AllowedIPs2=%@@10%" "Endpoint=%@@11%"
    For %%i In (%All%) Do set %%i
 
exit /B
 
:read_conf_m
    For /f "UseBackQ Tokens=1* Delims=:" %%A IN (`findstr /N /R /C:"." %/dp%%name_conf_wgcf-profile%`) Do set "@@%%A=%%B"
    set All="[Interface]=%@@1%" "PrivateKey=%@@2%" "wgListenPort=%@@3%" "Address=%@@4%" "Address2=%@@5%" "DNS=%@@6%" "MTU=%@@7%" "[Peer]=%@@8%" "PublicKey=%@@9%" "AllowedIPs=%@@10%" "AllowedIPs2=%@@11%" "Endpoint=%@@12%"
    For %%i In (%All%) Do set %%i
exit /B

:echo_conf_m
cls
echo -----------------------------------------------------------
echo                   Readed configurations:
echo -----------------------------------------------------------
echo 1  :%[Interface]%
echo 2  :%PrivateKey%
echo 3  :%wgListenPort%
echo 4  :%Address%
echo 5  :%Address2%
echo 6  :%DNS%
echo 7  :%MTU%
echo 8  :%[Peer]%
echo 9  :%PublicKey%
echo 10 :%AllowedIPs%
echo 11 :%AllowedIPs2%
echo 12 :%Endpoint%
echo -----------------------------------------------------------
echo cfg path: %/dp%%name_conf_wgcf-profile%
pause
exit /b

:echo_conf
cls
echo -----------------------------------------------------------
echo                   Readed configurations:
echo -----------------------------------------------------------
echo 1  :%[Interface]%
echo 2  :%PrivateKey%
echo 3  :%Address%
echo 4  :%Address2%
echo 5  :%DNS%
echo 6  :%MTU%
echo 7  :%[Peer]%
echo 8  :%PublicKey%
echo 9  :%AllowedIPs%
echo 10 :%AllowedIPs2%
echo 11 :%Endpoint%
echo 12 :
echo -----------------------------------------------------------
echo cfg path: %/dp%%name_conf_wgcf-profile%
pause
exit /b

:move_conf_WG
cls
move /y "%/dp%%name_conf_wgcf-profile%" "%/wg_cfg%\%name_conf_wgcf-profile%" >nul
color 20
echo ====================================
echo        new cfg is moved to
echo ====================================
echo %name_conf_wgcf-profile% here: %/wg_cfg%\%name_conf_wgcf-profile%
timeout /t 2 /nobreak >nul
color 07
exit /b
