xcopy ".\Scripts\*" "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\v1.0.0\Scripts" /S /I /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.dll" "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\v1.0.0" /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.dll" "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\v1.0.0" /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.UI\bin\Release\QESTNET.Upgrade.UI.exe" "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\v1.0.0" /R /Q /Y
xcopy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter.UI\bin\Release\QESTNET.Upgrade.ScriptWriter.UI.exe" "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\v1.0.0" /R /Q /Y
copy ".\QESTNET.Upgrade\QESTNET.Upgrade.UI\App.config.default" "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\v1.0.0\QESTNET.Upgrade.UI.exe.config" /Y
copy ".\QESTNET.Upgrade\QESTNET.Upgrade.ScriptWriter.UI\App.config.default" "\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\v1.0.0\QESTNET.Upgrade.ScriptWriter.UI.exe.config" /Y
@pause