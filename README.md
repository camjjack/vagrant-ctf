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
* For socat binaries I use the ctfrun script in the tools directory.

# setup
Build the required vagrant box file with packer

        git submodule update --init --recursive
        cd packer-templates
        ./build.sh -a
        ./build-windows.sh -a
        or if windows host:
        ./build.ps1 --vagrantAdd
        ./build-windows.ps1 --vagrantAdd
        cd ..

# configuration
        Modify `group_vars\private.yml` to include the following optional variables for ansible in ctf-ubuntu:
            1. pia_username
            1. pia_password
            1. git_username
            1. git_email

# run
        vagrant up [ctf-ubuntu, ctf-win, ctf-kali]

# notes / issues

* Kali box file does not exist for hyper-v and i haven't created one yet. so `vagrant up` or `vagrant up ctf-kali` will not work on windows.
* Firefox plugin installs would be nice

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

 * Private Internet Access
    1. Requires pia_username and pia_password to be set in group_vars/private.yml

 * Git configuration (git is always installed)
    1. Requires git_username and git_email to be set in group_vars/private.yml

Will write configuration if pia_username set in ansible args.
Use this format for `group_vars/private.yml` Note this file does not exist and is set in .gitignore so it isn't accidentaly commited to the repo.

        ---
        pia_username: '<username_here>'
        pia_password: '<password_here>'


# ctf-ubuntu
1. Default user is vagrant
1. Default password is vagrant
1. Tools located in ~/tools/