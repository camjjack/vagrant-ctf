# -*- mode: ruby -*-
# vi: set ft=ruby :
file_to_disk = File.realpath( "." ).to_s + "/disk.vdi"



Vagrant.configure("2") do |config|
  config.vm.define "ctf-ubuntu" do |ubuntu|
    
    ubuntu.vm.box = "../hyper-v-packer-templates/dist/virtualbox-ubuntu-xenial-enhanced.box"
    ubuntu.vm.hostname = "invalid-ctf"
    ubuntu.ssh.username = 'vagrant'
    ubuntu.ssh.password = 'vagrant'
    ubuntu.ssh.forward_agent = true 
    #ubuntu.vm.provision :shell, :path => "vagrant_setup.sh", :privileged => false
    ubuntu.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.galaxy_role_file = "requirements.yml"
      #ansible.become = true
    end


    ubuntu.vm.synced_folder "host-share", "/media/host-share"

    ubuntu.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--vram", "256"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      vb.customize ["modifyvm", :id, "--usb", "on"]     
      vb.gui = true
    end
    ubuntu.vm.network "public_network", bridge: "Default Switch"
    ubuntu.vm.provider "hyperv" do |hv|
      hv.enable_virtualization_extensions = true
      hv.differencing_disk = true
    end
  end

  config.vm.define "ctf-win" do |win|
    win.vm.box = "StefanScherer/windows_10"
    win.vm.hostname = "invalid-ctf-win"
    win.vm.provision "file", source: "./windows", destination: "c:\\vagrant"
    win.vm.provision "file", source: "./host-share", destination: "c:\\host-share"
    win.vm.provision "file", source: "./chocolatey", destination: "c:\\host-share"
    win.vm.provision "file", source: "./group_vars", destination: "c:\\host-share"
    win.vm.provision "file", source: "windows/BoxStarterGist.txt", destination: "c:\\vagrant\\BoxStarterGist.txt"
    win.vm.provision "shell", path: "windows/installChocolatey.ps1"
    win.vm.provision "shell", path: "windows/installBoxStarter.bat"
    win.vm.provision "shell", inline: "Install-BoxStarterPackage -PackageName c:\\vagrant\\BoxstarterGist.txt"

    win.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--vram", "128"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      vb.customize ["modifyvm", :id, "--usb", "on"]    
      vb.customize ["modifyvm", :id, "--monitorcount", "1"]   
      vb.gui = true
    end
    win.vm.network "public_network", bridge: "Default Switch"
    win.vm.provider "hyperv" do |hv|
      hv.enable_virtualization_extensions = true
      hv.differencing_disk = true
    end
  end
  config.vm.define "ctf-kali" do |kali|
    kali.vm.box = "unisec/kali-linux-2017.1-amd64"
    kali.vm.hostname = "invalid-ctf-kali"
    kali.vm.provision "ansible_local" do |ansible|
      kali.playbook = "kali-playbook.yml"
    end

    kali.vm.synced_folder "host-share", "/media/host-share"

    kali.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
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
      hv.differencing_disk = true
    end
  end
end
