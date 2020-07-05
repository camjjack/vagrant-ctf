$ErrorActionPreference = 'Stop';

$url64       = 'https://www.sweetscape.com/download/010EditorWin64Installer.exe'
$checksum64  = '6243561654D11962812352683DB3910C2A4BAEBD1D68A209D2D939F100E40966'

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