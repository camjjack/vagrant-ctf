$ErrorActionPreference = 'Stop';

$url64       = 'https://www.sweetscape.com/download/010EditorWin64Installer.exe'
$checksum64  = '0D94F62333EE27AB557BCADA351F850BDACC43F8F051EE42B6360264B5CABE53'

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