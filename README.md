#qestnet.upgrade

###Public Release Build Process
1. **Fetch the latest** of the branch *release-2.0* from origin.
    *git pull release-2.0*

2. **Checkout** *release-2.0* and **merge** in the branch(es).  
	*git checkout release-2.0*
	*git merge batman*
	
3. **Push** the merge and any manual commits on *release-2.0* to Git.
	*git push origin release-2.0*
	
4. **Open** TeamCity (http://adlv0033.sqaus.com:58590/) and go to the [Parameters](http://adlv0033.sqaus.com:58590/admin/editProject.html?projectId=QestnetUpgrade_2&tab=projectParams) section of Edit Settings of the QESTNET.Upgrade 2.0 root project.

5. **Edit** the *System.Version* parameter and set the *Value* to the required *major.minor* version, then **Save**.  This will update the *major.minor* version.

6. Open the [Release](http://adlv0033.sqaus.com:58590/viewType.html?buildTypeId=QestnetUpgrade_2_Release) project and click **Run**.

7. When prompted *"Build release?"* enter "y" or "yes" and click **Run Build**.

The build will then be generated and the full version tag pushed up to Git automatically. The output can be found in *"\\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\Builds\Release\"*.

A version of the release with the ScriptWriter removed is also posted to *"\\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\"* as a **public release**.  Any subsequent build of the same version number will overwite the previous one.
