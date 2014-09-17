
@REM Note: this publishes to ADLS0003 from the individual project release bins

xcopy ".\Scripts\*" ".\temp\Scripts" /S /I /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.dll" ".\temp" /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.dll" ".\temp" /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.UI\bin\Release\QESTNET.Upgrade.UI.exe" ".\temp" /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter.UI\bin\Release\QESTNET.Upgrade.ScriptWriter.UI.exe" ".\temp" /R /Q /Y

@REM xcopy ".\Libraries\Microsoft.SqlServer\Microsoft.SqlServer.Smo.dll" ".\temp" /R /Q /Y
@REM xcopy ".\Libraries\Microsoft.SqlServer\Microsoft.SqlServer.Management.Sdk.Sfc.dll" ".\temp" /R /Q /Y
@REM xcopy ".\Libraries\Microsoft.SqlServer\Microsoft.SqlServer.ConnectionInfo.dll" ".\temp" /R /Q /Y

copy ".\QESTNET.Upgrade\QESTNET.Upgrade.UI\App.config.default" ".\temp\QESTNET.Upgrade.UI.exe.config" /Y
copy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter.UI\App.config.default" ".\temp\QESTNET.Upgrade.ScriptWriter.UI.exe.config" /Y

@REM  FIXME:  Get the version number automatically
"C:\Program Files (x86)\7-Zip\7z.exe" a -t7z "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\QESTNET.Upgrade v1.0.0.1.7z" ".\temp\*"

rmdir "./temp" /S /Q
@pause