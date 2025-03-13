@echo off
title socd-settings
color 04
mode con: cols=50 lines=15
setlocal
:menu
cls
echo                   SOCD-SETTINGS
echo.
echo [1] Set custom keybinds
echo [2] Run socd when your PC starts
echo [3] Create a socd desktop shortcut
echo [4] Exit socd-settings
echo.
choice /c 1234 /n /m "Select an option: "
if errorlevel 4 goto exit
if errorlevel 3 goto create_desktop_shortcut
if errorlevel 2 goto move_to_startup
if errorlevel 1 goto confirm_keybinds
goto menu
:confirm_keybinds
cls
echo                 Made by @Streoids
echo do you want to set custom keybinds? (Y/N)
choice /c YN /n
if errorlevel 2 goto menu
if errorlevel 1 goto configure_keys
goto menu
:configure_keys
cls
echo                 Made by @Streoids
echo Enter the keys:
set /p forward=FORWARD KEY:  
set /p left=LEFT KEY:  
set /p right=RIGHT KEY:  
set /p backward=BACKWARD KEY:  
if "%forward%"=="" goto configure_keys
if "%left%"=="" goto configure_keys
if "%right%"=="" goto configure_keys
if "%backward%"=="" goto configure_keys
(
    echo Forward = %forward%
    echo Left = %left%
    echo Right = %right%
    echo Backward = %backward%
) > config.cfg
goto menu
:move_to_startup
cls
echo                 Made by @Streoids
echo Do you want socd to run when your PC starts? (Y/N)
choice /c YN /n
if errorlevel 2 goto menu
if errorlevel 1 goto create_startup_shortcut
goto menu
:create_startup_shortcut
cls
echo sending socd shortcut to startup folder
set "EXE_PATH=%~dp0socd.exe"
set "SHORTCUT_NAME=socd.lnk"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT_PATH=%STARTUP_FOLDER%\%SHORTCUT_NAME%"
if not exist "%EXE_PATH%" goto menu
if exist "%SHORTCUT_PATH%" goto menu
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath='%EXE_PATH%'; $s.WorkingDirectory='%~dp0'; $s.Save()"
goto menu
:create_desktop_shortcut
cls
echo                 Made by @Streoids
echo creating shortcut to desktop
set "EXE_PATH=%~dp0socd.exe"
set "DESKTOP_PATH=%USERPROFILE%\Desktop"
set "SHORTCUT_PATH=%DESKTOP_PATH%\socd.lnk"
if not exist "%EXE_PATH%" (
    echo socd.exe not found
    pause
    goto menu
)
if exist "%SHORTCUT_PATH%" (
    echo Shortcut already exists
    pause
    goto menu
)
:: Fixing PowerShell path issues
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT_PATH%'); $s.TargetPath='%EXE_PATH%'; $s.WorkingDirectory='%~dp0'; $s.Save()"
echo Shortcut created on your desktop
pause
goto menu
:exit
exit
