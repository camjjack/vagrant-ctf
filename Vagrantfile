# -*- mode: ruby -*-
# vi: set ft=ruby :
file_to_disk = File.realpath( "." ).to_s + "/disk.vdi"



Vagrant.configure("2") do |config|
  config.vm.define "ctf-ubuntu" do |ubuntu|
    
    #ubuntu.vm.box = "ubuntu/xenial64"
    ubuntu.vm.box = "xenial-server-cloudimg-amd64" # Basename of the url below
    ubuntu.vm.box_url = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-vagrant.box"
    config.ssh.username = "ubuntu"
    config.ssh.forward_agent = true 
    ubuntu.vm.hostname = "invalid-ctf"
    ubuntu.vm.provision :shell, :path => "add_new_disk.sh", :privileged => false
    #ubuntu.vm.provision :shell, :path => "vagrant_setup.sh", :privileged => false
    ubuntu.ssh.forward_agent = true


    ubuntu.vm.synced_folder "host-share", "/media/host-share"

    ubuntu.vm.provider "virtualbox" do |vb|
      if ARGV[0] == "up" && ! File.exist?(file_to_disk) 
        puts "Creating 200GB disk #{file_to_disk}."
        vb.customize [
            'createmedium',
             'disk ',
            '--filename', file_to_disk, 
           '--format', 'VDI', 
            '--size', 200000
            ] 
        vb.customize [
            'storageattach', :id, 
            '--storagectl', 'SCSI', 
            '--port', 2, '--device', 0, 
            '--type', 'hdd', '--medium', 
            file_to_disk
            ]
      end
      vb.customize ["modifyvm", :id, "--memory", "8192"]
      vb.customize ["modifyvm", :id, "--cpus", "4"]
      vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
      vb.customize ["modifyvm", :id, "--vram", "256"]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      vb.customize ["modifyvm", :id, "--usb", "on"]    
      vb.customize ["modifyvm", :id, "--monitorcount", "2"]   
      vb.gui = true
    end
  end
  config.vm.define "ctf-win" do |win|
    win.vm.box = "senglin/win-10-enterprise-vs2015community"
    win.vm.hostname = "invalid-ctf-win"
    win.vm.provision :ansible do |ansible|
      ansible.playbook = "windows-ansible.txt"
    end
    #config.vm.provision :shell, :path => "vagrant_setup.sh", :privileged => false
    #config.ssh.username = 'ubuntu'
    #config.ssh.forward_agent = true


    win.vm.synced_folder "host-share", "C:\\host-share"

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
  end
  config.vm.define "ctf-kali" do |kali|
    kali.vm.box = "unisec/kali-linux-2017.1-amd64"
    kali.vm.hostname = "invalid-ctf-kali"
    #config.vm.provision :shell, :path => "vagrant_setup.sh", :privileged => false
    #config.ssh.username = 'ubuntu'
    #config.ssh.forward_agent = true

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
  end
  
end