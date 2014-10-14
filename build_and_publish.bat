@echo off

if not exist "%~dp0build_and_publish.config.bat" copy "%~dp0build_and_publish.config.bat.default" "%~dp0build_and_publish.config.bat"
call "%~dp0build_and_publish.config.bat"

if NOT EXIST "%buildexe%" (
echo Build failed
echo.
echo Cannot find %buildexe%
echo Please check the configuration settings in %~dp0build_and_publish.config.bat
GOTO EOF
)
if NOT EXIST "%sevenzipexe%" (
echo Build failed
echo.
echo Cannot find %sevenzipexe%
echo Please check the configuration settings in %~dp0build_and_publish.config.bat
GOTO EOF
)

if NOT EXIST "%publishfolder%\" (
echo Build failed
echo.
echo Cannot find %publishfolder%
echo Please check the configuration settings in %~dp0build_and_publish.config.bat
GOTO EOF
)

:BUILD_MENU
echo Build
echo ^> 1. Development
echo ^> 2. Release
echo ^> 0. Exit
echo.
SET /P UserInput=Please enter a number:

IF %UserInput% EQU 0 GOTO EOF
IF %UserInput% EQU 1 GOTO BUILD_DEV
IF %UserInput% EQU 2 GOTO BUILD_RELEASE
goto BUILD_MENU

:BUILD_DEV
set buildtype=DEV
GOTO BUILD

:BUILD_RELEASE
set buildtype=RELEASE
GOTO BUILD

:BUILD
cd "%~dp0"
"%buildexe%" /nologo /p:Configuration=RELEASE /verbosity:minimal ".\QESTNET.Upgrade\QESTNET.Upgrade.sln"
if errorlevel 1 (
echo.
echo BUILD ERROR
goto EOF
) else (
echo.
echo BUILD OK
)

REM extract the version number from the manifest file
setlocal ENABLEDELAYEDEXPANSION
for /f %%s in (.\Scripts\database_upgrade.qn.manifest) do (
set tmp=%%s
IF "!tmp:~0,1!"=="#" (
set VER=!tmp:~1!
)
)
REM strip out spaces - there may be trailing spaces at the end of the version number
set VER=%VER: =%

REM Make sure that the version number only contains digits and dots [0-9.]
:CHECK_VERSION_NUMBER
echo %VER%|findstr /r /c:"^[0-9.][0-9.]*$" >nul
if errorlevel 1 (
echo Invalid Version Number: %VER%
set /P VER=Please enter the version number
GOTO CHECK_VERSION_NUMBER
) else (
echo Version: "%VER%"
)

xcopy ".\Scripts\*" ".\temp\Scripts" /S /I /R /Q /Y
del /S ".\temp\Scripts\*.orig"
del /S ".\temp\Scripts\*.bak"
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.dll" ".\temp" /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.UI\bin\Release\QESTNET.Upgrade.UI.exe" ".\temp" /R /Q /Y
copy ".\QESTNET.Upgrade\QESTNET.Upgrade.UI\App.config.default" ".\temp\QESTNET.Upgrade.UI.exe.config" /Y

REM Release build -- we don't need the script writer component, or SQL server library for this one:
IF "%buildtype%"=="RELEASE" (
if exist "%publishfolder%\QESTNET.Upgrade.v%VER%.7z" ( move /Y "%publishfolder%\QESTNET.Upgrade.v%VER%.7z" "%publishfolder%\QESTNET.Upgrade.v%VER%.7z.bak" )
"%sevenzipexe%" a -t7z "%publishfolder%\QESTNET.Upgrade.v%VER%.7z" ".\temp\*"
)

xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.dll" ".\temp" /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter.UI\bin\Release\QESTNET.Upgrade.ScriptWriter.UI.exe" ".\temp" /R /Q /Y
xcopy ".\Libraries\Microsoft.SqlServer\v11.0\*" ".\temp" /R /Q /Y
copy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter.UI\App.config.default" ".\temp\QESTNET.Upgrade.ScriptWriter.UI.exe.config" /Y

IF "%buildtype%"=="DEV" (
if exist "%publishfolder%\QESTNET.Upgrade.v%VER%.dev.7z" ( move /Y "%publishfolder%\QESTNET.Upgrade.v%VER%.dev.7z" "%publishfolder%\QESTNET.Upgrade.v%VER%.dev.7z.bak" )
"%sevenzipexe%" a -t7z "%publishfolder%\QESTNET.Upgrade.v%VER%.dev.7z" ".\temp\*"
)

rmdir "./temp" /S /Q

:EOF
echo.
pause
