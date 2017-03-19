#!/bin/bash
USER=invalid

# Create our new user, set password to username
sudo adduser --disabled-password --gecos "" $USER
echo $USER:$USER | sudo chpasswd
sudo usermod -aG sudo $USER

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

# Switch to the new user
sudo -Ssu $USER
# and sudo at least once to allow scripts below to sudo without password prompt
echo $USER | sudo -S ls
cd /home/$USER

# Updates
sudo apt-get -y update
sudo apt-get -y upgrade

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

# default to python2
#sudo apt-get -y install python2.7
#sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
#sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 10

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

mkdir -p tools
cd tools

# Install pwndbg
git_update pwndbg https://github.com/zachriggle/pwndbg ./setup.sh

# Install radare2
git_update radare2 https://github.com/radare/radare2 ./sys/install.sh

# Install angr
sudo apt-get -y install python-dev libffi-dev build-essential virtualenvwrapper
mkdir angr
pushd angr
mkvirtualenv angr && pip install angr
popd

# Make a bin dir and add to PATH
mkdir -p /home/$USER/tools/bin
echo 'PATH=$PATH:/home/$USER/tools/bin/' > /home/$USER/.bashrc
source /home/$USER/.bashrc

# socat ctf helper
sudo apt-get -y install socat
git_update ctfrun https://github.com/camjjack/ctfrun.git   
mkdir -p bin
pushd bin
ln -sf ../ctfrun/ctfrun .
popd

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
if [ -d "/home/$USER/.pia_manager" ]; then
    pushd Downloads
    wget https://installers.privateinternetaccess.com/download/pia-v68-installer-linux.tar.gz
    tar -xzf pia-v68-installer-linux.tar.gz
    pushd pia-v68-installer-linux
    ./pia-v68-installer-linux.sh
    popd
    popd
    echo '{"first_run":false,"region":"us1","proto":"udp","rport":"auto","lport":"","symmetric_cipher":"aes-256-cbc","symmetric_auth":"sha256","handshake_enc":"rsa4096","portforward":false,"killswitch":false,"dnsleak":false,"ipv6leak":true,"mssfix":false,"run_on_startup":true,"connect_on_startup":true,"show_popup_notifications":true,"user":"","pass":"","mace":false,"lang":"en-US"}' > /home/$USER/.pia_manager/data/settings.json
fi

# tor
sudo apt-get -y install tor 

# Haven't worked out how to do this just yet
#pushd Downloads
#wget https://addons.mozilla.org/firefox/downloads/latest/foxyproxy-basic/addon-15023-latest.xpi
#wget https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-on-tor/addon-652418-latest.xml
#sudo mv addon-15023-latest.xpi /home/$USER/.mozilla/extensions/
#sudo mv addon-652418-latest.xml /home/$USER/.mozilla/extensions/

# nicities

# Powerline
sudo apt-get -y install powerline fonts-powerline python3-powerline
if ! grep "powerline.sh" /home/$USER/.bashrc > /dev/null
then
    echo 'source /usr/share/powerline/bindings/bash/powerline.sh' >> /home/$USER/.bashrc
fi

if ! grep "Powerline" /home/$USER/.vimrc > /dev/null
then
    tee -a /home/$USER//.vimrc << EOF
" Powerline
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
EOF
fi

if ! grep "Powerline" /home/$USER/.tmux.conf > /dev/null
then
    tee -a /home/$USER/.tmux.conf << EOF
# Powerline
source /usr/share/powerline/bindings/tmux/powerline.conf
set-option -g default-terminal "screen-256color"
EOF
fi

# vs code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get -y update
sudo apt-get -y install code

# todo, git clone my config repo.