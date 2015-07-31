#qestnet.upgrade

###Development Release Build Process
Development releases are automatically built by TeamCity whenever changes are pushed to the *dev-1.0* branch.  
The output can be found in *"\\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\Builds\Development\"*

###Public Release Build Process
1. **Fetch the latest** of the branches *dev-1.0* and *release-1.0* from origin.
    *git pull --all*

2. **Advance** your local branches *dev-1.0* and *release-1.0* to the latest origin heads. 
	*git merge -ff-only origin/dev-1.0*
	
2. **Checkout** *release-1.0* and **merge** in the *dev-1.0* branch.  
	NOTE: A *qest_objects.qn.sql* conflict is likely from differences between dev and release in VSS	
	*git checkout release-1.0*
	*git merge dev-1.0*
	
3. **Make any additional changes** to *release-1.0* required and commit those.  
	e.g. *qest_objects.qn.sql* from the correct branch
	NOTE: Developers have been informed that only changes pertaining to the issue should be committed to avoid "noise" from other developers' checkins.

4. **Push** the merge and any manual commits on *release-1.0* to Git.
	*git push origin release-1.0*
	
5. **Open** TeamCity (http://adlv0033.sqaus.com:58590/) and go to the [Parameters](http://adlv0033.sqaus.com:58590/admin/editProject.html?projectId=QestnetUpgrade&tab=projectParams) section of Edit Settings of the QESTNET.Upgrade root project.

6. **Edit** the *System.Version* parameter and set the *Value* to the required *major.minor* version, then **Save**.  This will update the *major.minor* version for both Release and Development.

7. Open the [Release](http://adlv0033.sqaus.com:58590/viewType.html?buildTypeId=QestnetUpgrade_Release) project and click **Run**.

8. When prompted *"Build release?"* enter "y" or "yes" and click **Run Build**.

The build will then be generated and the full version tag pushed up to Git automatically. The output can be found in *"\\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\Builds\Release\"*.

A version of the release with the ScriptWriter removed is also posted to *"\\\ADLS0003\Development\Product Distribution\QESTNET.Upgrade\"* as a **public release**.  Any subsequent build of the same version number will overwite the previous one.