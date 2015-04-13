Clear-Host
$directory = Split-Path $script:MyInvocation.MyCommand.Path

foreach ($file in Get-ChildItem -path $directory -Recurse -Include *.default)
{
    $targetName = $file.FullName.SubString(0, $file.FullName.Length - 8)
    if(!(Test-Path $targetName -PathType Leaf))
    {
        Write-Host "Copying" $file.FullName "to" $targetName
        Copy-Item $file $targetName
    }
}

 Write-Host "Done." 