# vagrant-ctf
CTF environment provisioned by vagrant

# Requirements
* Virtualbox or Hyper-V
* vagrant

# My ctf environment
This sets up a ctf environment i've been using ad-hoc for a little while. Its not perfect but enough to get you up and running.

Some things I do are:
* Always use private internet access for a vpn. (Other vpn services are available)
* Use Dropbox to share ctf files between VMs. This is my persistant storage with all my previous ctf problems and solutions.
* Do most of my work in the ubuntu VM. Kali for pen testing tools, and windows for when its required


# run
        vagrant up [ctf-ubuntu, ctf-win, ctf-kali]

# Conditional Installs

 * Binaryninja
    1. Requires BinaryNinja*.[zip,exe] in host-share directory
    1. Requires license.txt in host-share directory

 * IDAPro for Windows
    1. Requires idaprocw*.exe in host-share directory
    1. Requires ida-password.txt in host-share directory

 * Private Internet Access

Will write configuration if pia_username set in ansible args.
Use this format for `group_vars/private.yml` Note this file does not exist and is set in .gitignore so it isn't accidentaly commited to the repo.

        ---
        pia_username: '<username_here>'
        pia_password: '<password_here>'


# ctf-ubutnu
1. Default user is vagrant
1. Default password is vagrant
1. Tools located in ~/tools/