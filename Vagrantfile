# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'socket'
host_address = IPAddr.new(Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address)
range = host_address.mask(20)
dhcp_start = range | "0.0.1.10"
dhcp_end = dhcp_start | "0.0.0.100"
gateway = range | "0.0.0.1"

Vagrant.configure("2") do |config|
  
  config.vm.define "ctf-ubuntu" do |ubuntu|    
    ubuntu.vm.box = "ubuntu-enhanced"
    ubuntu.vm.hostname = "invalid-ctf"
    ubuntu.ssh.username = 'vagrant'
    ubuntu.ssh.password = 'vagrant'
    ubuntu.ssh.forward_agent = true
    ubuntu.vm.provision "ansible_local" do |ansible|
      ansible.install_mode = "pip3"
      ansible.playbook = "playbook.yml"
    end

    ubuntu.vm.synced_folder "host-share", "/media/host-share"

    ubuntu.vm.network "public_network", bridge: "Default Switch"
    ubuntu.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = 4096
      vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--memory", "8192"]
      vb.customize ["modifyvm", :id, "--cpus", "6"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--vram", "256"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      vb.customize ["modifyvm", :id, "--usb", "on"]     
      vb.gui = true
    end
    ubuntu.vm.provider "hyperv" do |hv|
      hv.linked_clone = true
      hv.vm_integration_services = {
        guest_service_interface: true
      }
      hv.enable_virtualization_extensions = true
      hv.enable_enhanced_session_mode = true
    end
  end

  config.vm.define "ctf-win" do |win|
    win.vm.box = "windows"
    win.vm.hostname = "invalid-ctf-win"
    win.vm.communicator = "winrm"
    win.vm.provision "shell", path: "windows/installChocolatey.ps1"
    win.vm.provision "shell", path: "windows/installBoxStarter.bat"
    win.vm.provision "shell", inline: "Install-BoxStarterPackage -PackageName c:\\vagrant\\windows\\BoxstarterGist.txt -DisableReboots"
    win.vm.provision "shell", inline: "Install-BoxStarterPackage -PackageName c:\\vagrant\\windows\\BoxstarterGistCustom.txt -DisableReboots"

    win.vm.provider "virtualbox" do |vb|
      vb.cpus = 4
      vb.memory = 4098
      vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxsvga"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--vram", "256"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      vb.customize ["modifyvm", :id, "--usb", "on"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]  
      vb.gui = true
    end
    win.vm.network "public_network", bridge: "Default Switch"
    win.vm.provider "hyperv" do |hv|
      hv.linked_clone = true
      hv.cpus = 4
      hv.maxmemory = 8096
      hv.vm_integration_services = {
        guest_service_interface: true
      }
      hv.enable_virtualization_extensions = true
      hv.enable_enhanced_session_mode = true
    end
  end
  config.vm.define "ctf-kali" do |kali|
    kali.vm.box = "kalilinux/rolling"
    kali.vm.hostname = "invalid-ctf-kali"
    kali.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "kali-playbook.yml"
    end

    kali.vm.synced_folder "host-share", "/media/host-share"

    kali.vm.provider "virtualbox" do |vb|
      vb.cpus = 1
      vb.memory = 2048
      vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxsvga"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--vram", "128"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      vb.customize ["modifyvm", :id, "--usb", "on"]    
      vb.customize ["modifyvm", :id, "--monitorcount", "1"]   
      vb.gui = true
    end
    kali.vm.network "public_network", bridge: "Default Switch"
    kali.vm.provider "hyperv" do |hv|
      hv.enable_virtualization_extensions = true
      hv.linked_clone = true
    end
  end
  config.vm.define "arch" do |arch|    
    arch.vm.box = "arch-desktop"
    arch.vm.hostname = "arch-dev"
    arch.ssh.username = 'vagrant'
    arch.ssh.password = 'vagrant'
    arch.ssh.forward_agent = true
    arch.vm.provision "shell" do |update|
      update.inline = "pacman -Syu --noconfirm"
      update.reboot = true
    end
    arch.vm.provision "ansible_local" do |ansible|
      ansible.install_mode = "pip3"
      ansible.playbook = "playbook.yml"
      ansible.galaxy_role_file = "requirements.yml"
    end

    arch.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: [".git/", "packer-templates/"]

    arch.vm.network "public_network", bridge: "WSL"
    arch.vm.provider "hyperv" do |hv|
      hv.vm_integration_services = {
        guest_service_interface: true
      }
      hv.enable_virtualization_extensions = true
      hv.enable_enhanced_session_mode = true
      # dynamic memory causes systemd-journal to use 99% cpu
      # on the fix: https://github.com/torvalds/linux/commit/96d9d1fa5cd505078534113308ced0aa56d8da58#diff-69ad06175a1bd732f670c8a14108b9bc7aaee781daae61c4d65c6146933a3de4
      # lands in a downstream kernel we can remove this
      hv.memory = 4096
    end
  end
  config.vm.define "vyos" do |vyos|    
    vyos.vm.box = "vyos"
    vyos.vm.hostname = "vyos"
    vyos.ssh.username = 'vyos'
    vyos.ssh.password = 'vagrant'
    vyos.ssh.forward_agent = true
    vyos.vm.provision "shell" do |s|
      s.path = "scripts/vyos-dhcp.sh"
      s.env   = {:RANGE => range.to_s() + "/20",
                 :DEFAULT_ROUTER => gateway.to_s(),
                 :DHCP_START => dhcp_start.to_s(),
                 :DHCP_END => dhcp_end.to_s(),
                 :NAMESERVER => gateway.to_s(),
                 :DOMAIN_NAME => "vyos.net"
                }
    end

    vyos.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: [".git/", "packer-templates/"]

    vyos.vm.network "public_network", bridge: "WSL"
  end
end
