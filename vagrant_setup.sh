#!/bin/bash

git_update() {
    if [ -d $1 ]; then
        pushd $1
        git pull
    else
        git clone $2
        pushd $1
    fi
    if [ ! -z "$3" ]; then 
        $3
    fi
    popd
}

#locale fix up
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
sudo locale-gen
sudo localectl set-x11-keymap us
sudo localectl set-locale LANG="en_US.UTF-8"

# Updates
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -o "Dpkg::Options::=--force-confold" upgrade -y

# multilib
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386

sudo apt-get -y install pidgin

# Desktop manager
sudo apt-get install ubuntu-desktop

# default tools
sudo apt-get -y install tmux
sudo apt-get -y install vim
sudo apt-get -y install gdb gdb-multiarch
sudo apt-get -y install unzip
sudo apt-get -y install git

# Setup python
sudo pip install --upgrade pip
pip install --upgrade pip

# Virtualbox tools
sudo apt-get -y install virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
sudo VBoxClient --clipboard
sudo VBoxClient --draganddrop
sudo VBoxClient --display
sudo VBoxClient --checkhostversion
sudo VBoxClient --seamless

# Install pwntools
sudo apt-get -y install python2.7 python-pip python-dev git libssl-dev libffi-dev build-essential
sudo pip install --upgrade pwntools

cd
mkdir -p tools
pushd tools

# Install pwndbg
git_update pwndbg https://github.com/zachriggle/pwndbg ./setup.sh

# Install radare2
git_update radare2 https://github.com/radare/radare2 ./sys/install.sh

# Install angr
if workon angr; then
    pip install --upgrade angr
else
    sudo apt-get -y install python-dev libffi-dev build-essential virtualenvwrapper
    pip install pip
    mkvirtualenv angr && pip install angr
fi

# Make a bin dir and add to PATH
if [ ! -d "/home/$USER/tools/bin" ]; then
    mkdir -p ~/tools/bin
    echo 'PATH=$PATH:~/tools/bin/' >> ~/.bashrc
    source ~/.bashrc
fi

# socat ctf helper
if ! which socat; then
    sudo apt-get -y install socat
fi
git_update ctfrun https://github.com/camjjack/ctfrun.git   

if ! which ctfrun; then
    pushd bin
    ln -sf ../ctfrun/ctfrun .
    popd
fi

# unicorn
pip install --upgrade unicorn

# keystone
sudo apt-get -y install cmake
git_update keystone https://github.com/keystone-engine/keystone.git
pushd keystone
mkdir -p build
if ! [ -f /etc/ld.so.conf.d/keystone.conf]
then
    tee /etc/ld.so.conf.d/keystone.conf << EOF
# keystone default configuration
/usr/local/lib
EOF
    sudo ldconfig
fi
pushd build
../make-share.sh
sudo make install
popd
popd

# QEMU with MIPS/ARM - http://reverseengineering.stackexchange.com/questions/8829/cross-debugging-for-mips-elf-with-qemu-toolchain
sudo apt-get -y install qemu qemu-user qemu-user-static
sudo apt-get -y install 'binfmt*'
sudo apt-get -y install libc6-armhf-armel-cross libc6-mipsel-cross libc6-arm-cross
sudo mkdir -p /etc/qemu-binfmt
sudo ln -sf /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel 
sudo ln -sf /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm

sudo apt-get -y install chromium-browser

# pia
if [ ! -d "/home/$USER/.pia_manager" ]; then
    cd
    pushd Downloads
    wget https://installers.privateinternetaccess.com/download/pia-v68-installer-linux.tar.gz
    tar -xzf pia-v68-installer-linux.tar.gz
    pushd pia-v68-installer-linux
    ./pia-v68-installer-linux.sh
    popd
    popd
    if [ -e "/media/host-share/pia-pass.txt" ]; then
        echo '{"first_run":false,"region":"us1","proto":"udp","rport":"auto","lport":"","symmetric_cipher":"aes-256-cbc","symmetric_auth":"sha256","handshake_enc":"rsa4096","portforward":false,"killswitch":false,"dnsleak":false,"ipv6leak":true,"mssfix":false,"run_on_startup":true,"connect_on_startup":true,"show_popup_notifications":true,"mace":false,"lang":"en-US"' > ~/.pia_manager/data/settings.json
        cat /media/host-share/pia-pass.txt >> ~/.pia_manager/data/settings.json
        echo '}' >> ~/.pia_manager/data/settings.json
    else
        echo '{"first_run":false,"region":"us1","proto":"udp","rport":"auto","lport":"","symmetric_cipher":"aes-256-cbc","symmetric_auth":"sha256","handshake_enc":"rsa4096","portforward":false,"killswitch":false,"dnsleak":false,"ipv6leak":true,"mssfix":false,"run_on_startup":true,"connect_on_startup":true,"show_popup_notifications":true,"user":"","pass":"","mace":false,"lang":"en-US"}' > ~/.pia_manager/data/settings.json
    fi
fi

# tor
sudo apt-get -y install tor 

#lastpass
if [ ! -d "/home/$USER/Downloads/lplinux" ]; then
    cd
    pushd Downloads
    wget https://lastpass.com/lplinux.tar.bz2
    tar xjvf lplinux.tar.bz2
    pushd lplinux && ./install_lastpass.sh
    popd
    popd
fi

#dropbox

if ! which dropbox; then
    cd
    pushd Downloads
    wget https://linux.dropbox.com/packages/ubuntu/dropbox_2015.10.28_amd64.deb

    sudo DEBIAN_FRONTEND=noninteractive dpkg -i --force-confold dropbox_2015.10.28_amd64.deb
    rm dropbox_2015.10.28_amd64.deb
    popd
fi


# Haven't worked out how to do this just yet
#pushd Downloads
#wget https://addons.mozilla.org/firefox/downloads/latest/foxyproxy-basic/addon-15023-latest.xpi
#wget https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-on-tor/addon-652418-latest.xml
#sudo mv addon-15023-latest.xpi /home/$USER/.mozilla/extensions/
#sudo mv addon-652418-latest.xml /home/$USER/.mozilla/extensions/

# nicities

# Powerline
sudo apt --fix-broken -y install
sudo apt-get -y install powerline fonts-powerline python3-powerline
if ! grep "powerline.sh" ~/.bashrc > /dev/null
then
    echo 'source /usr/share/powerline/bindings/bash/powerline.sh' >> ~/.bashrc
fi

if ! grep "Powerline" ~/.vimrc > /dev/null
then
    tee -a ~/.vimrc << EOF
" Powerline
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
EOF
fi

if ! grep "Powerline" ~/.tmux.conf > /dev/null
then
    tee -a ~/.tmux.conf << EOF
# Powerline
source /usr/share/powerline/bindings/tmux/powerline.conf
set-option -g default-terminal "screen-256color"
EOF
fi

# vs code
if ! which code; then
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get -y update
    sudo apt-get -y install code
fi

# vs code extensions
# wont work. fix due in august release
#code --install-extension ms-vscode.cpptools
#code --install-extension donjayamanne.python
#code --install-extension robertohuertasm.vscode-icons
#code --install-extension donjayamanne.githistory
#code --install-extension PeterJausovec.vscode-docker

# wireshark
sudo DEBIAN_FRONTEND=noninteractive apt-get -o "Dpkg::Options::=--force-confold" install -y wireshark

# binary ninja
if [ -e "/media/host-share/BinaryNinja-personal.zip" ]; then
    if [ ! -d "/home/$USER/tools/binaryninja" ]; then
        cd
        pushd tools
        unzip /media/host-share/BinaryNinja-personal.zip
        pushd binaryninja
        cp /media/host-share/license.dat .
        ./linux-setup.sh
        popd
        popd
    fi
fi

# pylint for vscode
sudo pip install pylint

# one_gadget
sudo apt-get -y install ruby
suby gem install one_gadget

# todo, 010 editor
# todo, git clone my config repo.
