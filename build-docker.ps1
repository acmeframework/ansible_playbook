#
# This is a workaround for trying to build docker images while in a OneDrive
#  managed folder
#
# See: https://github.com/docker/for-win/issues/1290
#
$buildFolder = "ansible_playbook_build"
$buildDirectory = "$Env:TMP/$buildFolder"
$oldLocation = Get-Location

New-Item -Path $buildDirectory
Copy-Item Dockerfile $buildDirectory

Set-Location $buildDirectory
docker build -t acmeframework/ansible_playbook:2.5.3 .

Set-Location $oldLocation
Remove-Item -Path $buildDirectory -Recurse -Force