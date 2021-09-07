[![Build Status](https://dev.azure.com/camjjack/camjjack/_apis/build/status/camjjack.vagrant-ctf?branchName=master)](https://dev.azure.com/camjjack/camjjack/_build/latest?definitionId=1&branchName=master)

# vagrant-ctf
CTF environment provisioned by vagrant

# Requirements
* Virtualbox(linux host) or Hyper-V(Windows host)
* vagrant
* packer

# Building
Build the required vagrant box file with packer

```bash
(linux)./setup.sh

or if windows host:
(windows) .\setup.bat
```

# Runing
```bash
vagrant up [ctf-ubuntu, ctf-win, ctf-kali]
```
## Configuration
Modify `group_vars\private.yml` to include the following optional variables for ansible in ctf-ubuntu. Note this file does not exist and is set in .gitignore so it isn't accidentaly commited to the repo.
         
         ---
         pia_username: '<username_here>'
         pia_password: '<password_here>'
         git_username: '<username_here>'
         git_email: '<email_here>'

## Conditional Installs

 * Binaryninja Linux
    1. Requires BinaryNinja.zip in host-share directory
    1. Requires license.txt in host-share directory

 * Binaryninja for Windows
    1. Requires BinaryNinja.exe in chocolatey\binaryninja\tools directory
    1. Requires license.txt in host-share directory

 * IDAPro for Windows
    1. Requires idaprocw*.exe in host-share directory
    1. Requires ida-password.txt in host-share directory

# My ctf environment
This sets up a ctf environment i've been using ad-hoc for a little while. Its not perfect but enough to get you up and running.

Some things I do are:
* Always use private internet access for a vpn. (Other vpn services are available)
* Use Dropbox to share ctf files between VMs. This is my persistant storage with all my previous ctf problems and solutions.
* Do most of my work in the ubuntu VM. Kali for pen testing tools, and windows for when its required

# notes / issues

Make sure you have ruby 2.6 or later installed. Tested with 2.6.6

You also need bsdtar. For this i installed Vagrant via the installer then copied the included bsdtar to `C:\Windows\System32`. The default location is `C:\HashiCorp\Vagrant\embedded\mingw64\bin\bsdtar.exe`

* Kali box file does not exist for hyper-v and i haven't created one yet. so `vagrant up` or `vagrant up ctf-kali` will not work on windows.

# ctf-ubuntu
1. Default user is vagrant
1. Default password is vagrant
1. Tools located in ~/tools/
1. i3 wm is available