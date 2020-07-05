$ErrorActionPreference = 'Stop';

$url64       = 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi'
$checksum64  = 'F4833159D00077E160C4B87CA4C4066DA0B20BEC69331CD414A6CB62BD88DE70'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'msi'
  softwareName  = 'wsl2*'

  checksum64    = $checksum64
  checksumType64= 'sha256'
  url64bit      = $url64

  silentArgs   = '/quiet /qn /norestart'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs