
xcopy ".\Scripts\*" ".\temp\Scripts" /S /I /R /Q /Y
xcopy ".\Libraries\QESTNET.Upgrade\Release\QESTNET.Upgrade.dll" ".\temp" /R /Q /Y
xcopy ".\Libraries\QESTNET.Upgrade\Release\QESTNET.Upgrade.UI.exe" ".\temp" /R /Q /Y
xcopy ".\Libraries\QESTNET.Upgrade\Release\QESTNET.Upgrade.ScriptWriter.dll" ".\temp" /R /Q /Y
xcopy ".\Libraries\QESTNET.Upgrade\Release\QESTNET.Upgrade.ScriptWriter.UI.exe" ".\temp" /R /Q /Y

xcopy ".\Libraries\Microsoft.SqlServer\v11.0\*" ".\temp" /R /Q /Y

copy ".\QESTNET.Upgrade\QESTNET.Upgrade.UI\App.config.default" ".\temp\QESTNET.Upgrade.UI.exe.config" /Y
copy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter.UI\App.config.default" ".\temp\QESTNET.Upgrade.ScriptWriter.UI.exe.config" /Y

@REM  FIXME:  Get the version number automatically
del /Q "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\Debug\QESTNET.Upgrade v1.0.0.6.7z"
"C:\Program Files (x86)\7-Zip\7z.exe" a -t7z "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\Development\QESTNET.Upgrade v1.0.0.7.7z" ".\temp\*"

rmdir "./temp" /S /Q
@pause
