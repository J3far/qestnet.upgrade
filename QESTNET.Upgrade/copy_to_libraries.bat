

xcopy ".\QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.dll" "..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy ".\QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.pdb" "..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy ".\QESTNET.Upgrade\bin\Release\QESTNET.Upgrade.xml" "..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy ".\QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.dll" "..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy ".\QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.pdb" "..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y
xcopy ".\QESTNET.Upgrade.ScriptWriter\bin\Release\QESTNET.Upgrade.ScriptWriter.xml" "..\Libraries\QESTNET.Upgrade\Release\" /R /Q /Y

xcopy ".\QESTNET.Upgrade\bin\Debug\QESTNET.Upgrade.dll" "..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy ".\QESTNET.Upgrade\bin\Debug\QESTNET.Upgrade.pdb" "..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy ".\QESTNET.Upgrade\bin\Debug\QESTNET.Upgrade.xml" "..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy ".\QESTNET.Upgrade.ScriptWriter\bin\Debug\QESTNET.Upgrade.ScriptWriter.dll" "..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy ".\QESTNET.Upgrade.ScriptWriter\bin\Debug\QESTNET.Upgrade.ScriptWriter.pdb" "..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y
xcopy ".\QESTNET.Upgrade.ScriptWriter\bin\Debug\QESTNET.Upgrade.ScriptWriter.xml" "..\Libraries\QESTNET.Upgrade\Debug\" /R /Q /Y

del "..\Libraries\QESTNET.Upgrade\$(Configuration)\*" /Q
xcopy "..\Libraries\QESTNET.Upgrade\Debug\*" "..\Libraries\QESTNET.Upgrade\$(Configuration)\*" /R /Q /Y