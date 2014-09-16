@echo off

for /R . %%f in (*.default) do (
	if not exist %%~pf%%~nf (echo Copying %%~pf%%~nf.default to %%~nf & copy %%~pf%%~nf.default %%~pf%%~nf /y)
)

echo Done.