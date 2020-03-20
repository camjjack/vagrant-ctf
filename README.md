[![Build Status](https://dev.azure.com/camjjack/camjjack/_apis/build/status/camjjack.vagrant-ctf?branchName=master)](https://dev.azure.com/camjjack/camjjack/_build/latest?definitionId=1&branchName=master)

# vagrant-ctf
CTF environment provisioned by vagrant

# Requirements
* Virtualbox(linux host) or Hyper-V(Windows host)
* vagrant
* packer

# My ctf environment
This sets up a ctf environment i've been using ad-hoc for a little while. Its not perfect but enough to get you up and running.

Some things I do are:
* Always use private internet access for a vpn. (Other vpn services are available)
* Use Dropbox to share ctf files between VMs. This is my persistant storage with all my previous ctf problems and solutions.
* Do most of my work in the ubuntu VM. Kali for pen testing tools, and windows for when its required
* For socat binaries I use the ctfrun script in the tools directory - obsolute, now i use pwntools gdb.

# setup
Build the required vagrant box file with packer

        (linux)./setup.sh
        
        or if windows host:
        (windows) .\setup.bat

# configuration
Modify `group_vars\private.yml` to include the following optional variables for ansible in ctf-ubuntu. Note this file does not exist and is set in .gitignore so it isn't accidentaly commited to the repo.
         
         ---
         pia_username: '<username_here>'
         pia_password: '<password_here>'
         git_username: '<username_here>'
         git_email: '<email_here>'

# Conditional Installs

 * Binaryninja Linux
    1. Requires BinaryNinja.zip in host-share directory
    1. Requires license.txt in host-share directory

 * Binaryninja for Windows
    1. Requires BinaryNinja.exe in chocolatey\binaryninja\tools directory
    1. Requires license.txt in host-share directory

 * IDAPro for Windows
    1. Requires idaprocw*.exe in host-share directory
    1. Requires ida-password.txt in host-share directory

# run

        vagrant up [ctf-ubuntu, ctf-win, ctf-kali]

# notes / issues

Main issue is lack of support in mainline vagrant for enhanced session mode in Hyper-V. I have submitted a pull request but it has not been actioned yet. You can get this experience by checkout out that vagrant branch. https://github.com/hashicorp/vagrant/pull/11014

Once you have a vagrant dev environment with my mods you can use the version like this. (replace gemfile parameter with link to the checkout of the vagrant dev repo)

```
this_dir> bundle exec --gemfile=..\vagrant\Gemfile vagrant up ctf-ubuntu
```

* Kali box file does not exist for hyper-v and i haven't created one yet. so `vagrant up` or `vagrant up ctf-kali` will not work on windows.
* Firefox plugin installs would be nice

# ctf-ubuntu
1. Default user is vagrant
1. Default password is vagrant
1. Tools located in ~/tools/
1. i3 wm is available
