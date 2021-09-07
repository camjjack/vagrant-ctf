# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "ctf-ubuntu" do |ubuntu|    
    ubuntu.vm.box = "ubuntu-20.04"
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
    win.vm.box = "windows-10"
    win.vm.hostname = "invalid-ctf-win"
    win.vm.communicator = "winrm"
    win.vm.provision "shell", path: "windows/installChocolatey.ps1"
    win.vm.provision "shell", path: "windows/installBoxStarter.bat"
    win.vm.provision "shell", inline: "Install-BoxStarterPackage -PackageName c:\\vagrant\\windows\\BoxstarterGist.txt -DisableReboots"

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
end
