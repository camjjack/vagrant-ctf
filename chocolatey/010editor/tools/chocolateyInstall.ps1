$ErrorActionPreference = 'Stop';

$url64       = 'https://www.sweetscape.com/download/010EditorWin64Installer.exe'
$checksum64  = '0876781B04C63B8D031E67F2A4B24370D6B7C00DFB2274A5567A2E85E3EFDA4A'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  softwareName  = '010 Editor*'

  checksum64    = $checksum64
  checksumType64= 'sha256'
  url64bit      = $url64

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs