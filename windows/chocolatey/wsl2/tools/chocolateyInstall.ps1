$ErrorActionPreference = 'Stop';

$url64       = 'https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi'
$checksum64  = '1C8282796C48A04E379AA2BBBD30357C3D32EDFB23FE8B61F84017E34AB51CD2'

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