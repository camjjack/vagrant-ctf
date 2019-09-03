
$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$hostShare = "C:\host-share"
$INSTALLER_FILE = Join-Path $hostShare 'BinaryNinja.exe'
$LICENCE_FILE = Join-Path $hostShare 'license.txt'
$BINARY_NINJA_USER_DIR = "$($env:AppData)/Binary Ninja"
$LICENCE_INSTALL_LOC = "$($BINARY_NINJA_USER_DIR)/license.dat"


$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  file64        = $INSTALLER_FILE

  softwareName  = 'binaryninja*' 
 

  silentArgs    = "/S" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0)
}

if(Test-Path $INSTALLER_FILE) {
  Install-ChocolateyInstallPackage @packageArgs
  if(Test-Path $LICENCE_FILE) {
    mkdir -Path $BINARY_NINJA_USER_DIR
    copy-item -Path $LICENCE_FILE -Destination $LICENCE_INSTALL_LOC
  }
}