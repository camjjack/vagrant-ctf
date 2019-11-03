
Write-Output "update all submodules"
git submodule update --init --recursive

Push-Location -Path "packer-templates"
Write-Output "build the ubuntu vm"
& .\build.ps1 "--vagrantAdd"

Write-Output "build the windows vm"
& .\build-windows.ps1 "--vagrantAdd"
Pop-Location