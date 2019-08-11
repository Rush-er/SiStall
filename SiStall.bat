@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    
echo Installing Firefox
msiexec /q /i "msi\firefox.msi" REBOOT=ReallySuppress /L*V "logs\firefox.log"
echo OK
echo Installing Chrome
msiexec /q /i "msi\chrome.msi" REBOOT=ReallySuppress /L*V "logs\chrome.log"
echo OK
echo Installing 7zip
msiexec /q /i "msi\7z.msi" REBOOT=ReallySuppress /L*V "logs\7z.log"
echo OK
echo Installing Adobe reader DC Italian
msiexec /q /i "adobe\reader.msi" REBOOT=ReallySuppress /L*V "logs\reader.log"
echo OK
echo Installing Java
:: msiexec /q /i "C:\Users\Matis\Desktop\installer\Msi-silent-install\msi\java.msi" REBOOT=ReallySuppress /L*V "java.log"
start /d "msi\" java.exe
echo OK
echo Installation completed
@echo off
pause