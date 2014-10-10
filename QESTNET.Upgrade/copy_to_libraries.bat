
xcopy "%~dp0QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.dll" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.pdb" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.xml" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.dll" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.pdb" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.xml" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.UI\bin\Release\QESTNET.Upgrade.UI.exe" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.UI\bin\Release\QESTNET.Upgrade.UI.pdb" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.UI\bin\Release\QESTNET.Upgrade.UI.xml" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter.UI\bin\Release\QESTNET.Upgrade.ScriptWriter.UI.exe" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter.UI\bin\Release\QESTNET.Upgrade.ScriptWriter.UI.pdb" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter.UI\bin\Release\QESTNET.Upgrade.ScriptWriter.UI.xml" "%~dp0..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y

xcopy "%~dp0QESTNET.Upgrade\bin\Debug\QESTNET.Upgrade.dll" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade\bin\Debug\QESTNET.Upgrade.pdb" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade\bin\Debug\QESTNET.Upgrade.xml" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter\bin\Debug\QESTNET.Upgrade.ScriptWriter.dll" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter\bin\Debug\QESTNET.Upgrade.ScriptWriter.pdb" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter\bin\Debug\QESTNET.Upgrade.ScriptWriter.xml" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.UI\bin\Debug\QESTNET.Upgrade.UI.exe" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.UI\bin\Debug\QESTNET.Upgrade.UI.pdb" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.UI\bin\Debug\QESTNET.Upgrade.UI.xml" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter.UI\bin\Debug\QESTNET.Upgrade.ScriptWriter.UI.exe" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter.UI\bin\Debug\QESTNET.Upgrade.ScriptWriter.UI.pdb" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy "%~dp0QESTNET.Upgrade.ScriptWriter.UI\bin\Debug\QESTNET.Upgrade.ScriptWriter.UI.xml" "%~dp0..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y

del "%~dp0..\Libraries\QESTNET.Upgrade\$(Configuration)\*" /Q
xcopy "%~dp0..\Libraries\QESTNET.Upgrade\Debug\*" "%~dp0..\Libraries\QESTNET.Upgrade\$(Configuration)\*" /R /Q /Y