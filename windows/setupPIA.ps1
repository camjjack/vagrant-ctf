Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Force powershell-yaml

$var_file = "C:\vagrant\group_vars\private.yml"
if(Test-Path $var_file) {
    Write-Output "Private Internet Access data exists, configuring..."
    $private_data = Get-Content $var_file | Out-String

    $pia_config = ConvertFrom-Yaml $private_data

    $config = "{`"region`":`"us_california`",`"proto`":`"udp`",`"rport`":`"auto`",`"lport`":`"`",`"symmetric_cipher`":`"aes-256-cbc`",`"symmetric_auth`":`"sha256`",`"handshake_enc`":`"rsa4096`",`"portforward`":false,`"killswitch`":false,`"dnsleak`":false,`"ipv6leak`":true,`"mssfix`":false,`"run_on_startup`":true,`"connect_on_startup`":true,`"show_popup_notifications`":true,`"first_run`":false,`"user`":`"$($pia_config.pia_username)`",`"pass`":`"$($pia_config.pia_password)`",`"mace`":false,`"lang`":`"en-US`"}"

    Write-Output "writing config..."
    Set-Content -Path "C:\Program Files\pia_manager\data\settings.json" -Value $config
    Write-Output "done"
} else {
    
    Write-Output "Private Internet Access data doesn't exist, skipping"
}