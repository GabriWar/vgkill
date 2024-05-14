@echo off
:: Get Admin
::-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
::--------------------------------------
::CODE STARTS HERE::

echo . 
echo @@@  @@@   @@@@@@@@  @@@  @@@  @@@  @@@       @@@       
echo @@@  @@@  @@@@@@@@@  @@@  @@@  @@@  @@@       @@@       
echo @@!  @@@  !@@        @@!  !@@  @@!  @@!       @@!       
echo !@!  @!@  !@!        !@!  @!!  !@!  !@!       !@!       
echo @!@  !@!  !@! @!@!@  @!@@!@!   !!@  @!!       @!!       
echo !@!  !!!  !!! !!@!!  !!@!!!    !!!  !!!       !!!       
echo :!:  !!:  :!!   !!:  !!: :!!   !!:  !!:       !!:       
echo  ::!!:!   :!:   !::  :!:  !:!  :!:   :!:       :!:      
echo   ::::     ::: ::::   ::  :::   ::   :: ::::   :: ::::  
echo    :       :: :: :    :   :::  :    : :: : :  : :: : :  
echo                    Brought to you by @GabriWar                                                   
echo .  
:choice
echo [1] Kill tasks
echo [2] Enable Vanguard
echo [3] Soft enable Vanguard
echo [4] Disable Vanguard
echo [5] Soft disable Vanguard
echo [6] Check the status of Vanguard
if "%~1"=="-k" goto :killtasks
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A   
set /P c= ">"
if /I "%c%" EQU "1" goto :killtasks
if /I "%c%" EQU "2" goto :enable
if /I "%c%" EQU "3" goto :softenable
if /I "%c%" EQU "4" goto :disable
if /I "%c%" EQU "5" goto :softdisable
if /I "%c%" EQU "6" goto :check
goto :choice
::--------------------------------------
:killtasks
set loopcount=6
:loop
for /F %%T in (tokill.txt) do (
    taskkill /F /IM %%T
)
set /a loopcount=loopcount-1
if %loopcount%==0 goto exitloop
goto loop
:exitloop
pause
exit
::--------------------------------------
:check
sc query vgc
sc query vgk
echo.
set /P c=Return to menu?[Y/N]?
if /I "%c%" EQU "N" exit
if /I "%c%" EQU "Y" cls & goto :choice
::--------------------------------------
:enable
sc start vgc
sc start vgk
sc config vgk start= system
sc config vgc start= demand
goto:choice2
::--------------------------------------
:disable
sc config vgc start= disabled & 
sc config vgk start= disabled & 
sc stop vgc  
sc stop vgk  
taskkill /F /IM vgk.exe
pause
exit
:choice2
set /P c=Do you want to restart?(required to save changed)[Y/N]?
if /I "%c%" EQU "Y" goto :yes
if /I "%c%" EQU "N" goto :no
goto :choice2
:yes
echo restarting in 5 seconds
echo.
echo 5
ping -n 2 127.0.0.1>nul
echo 4
ping -n 2 127.0.0.1>nul
echo 3
ping -n 2 127.0.0.1>nul
echo 2
ping -n 2 127.0.0.1>nul
echo 1
ping -n 2 127.0.0.1>nul
shutdown.exe /r /t 00
:no
exit
::--------------------------------------
:softdisable
sc stop vgk
pause
exit
:softenable
sc start vgk
sc start vgc
pause
exit
