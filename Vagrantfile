# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml' # STEP ONE, REQUIRE YAML!
configFile = File.open('workstation.config', 'r')
workstation_config = YAML.load(configFile.read)

# printf YAML.load(config)
# printf YAML.dump("foo")
# config = {
#     'pasword' => 'BazStation11',
#     'rootPassword' => 'BazStation11'
#   }
# printf config['pasword']
# printf(config.to_yaml)

# KERNEL UPGRADE
# https://www.vagrantup.com/docs/vmware/kernel-upgrade.html
$fix_vmware_tools_script = <<SCRIPT
sed -i.bak 's/answer AUTO_KMODS_ENABLED_ANSWER no/answer AUTO_KMODS_ENABLED_ANSWER yes/g' /etc/vmware-tools/locations
sed -i 's/answer AUTO_KMODS_ENABLED no/answer AUTO_KMODS_ENABLED yes/g' /etc/vmware-tools/locations
SCRIPT

$set_passwords = <<SCRIPT
  echo Setting passwords
  echo "p1 = $1"
  echo "p2 = $2"
  echo "vagrant:$1" | chpasswd
  echo "root:$2" | chpasswd
  echo done?
SCRIPT

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "puppetlabs/centos-7.0-64-puppet"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #

  config.vm.provider "vmware_fusion" do |vw|
    vw.gui = true
    vw.vmx["memsize"] = "1024"
    vw.vmx["numvcpus"] = "2"
    vw.vmx["enable3d"] = "true"
  end

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  # config.vm.provision "VagrantPassword", type: "shell", privileged: true, inline: "echo vagrant:#{workstation_config['pasword']} | chpasswd"
  config.vm.provision "SetPasswords", type: "shell", privileged: true, inline: $set_passwords, args: [workstation_config['password'], workstation_config['rootPassword']]
  config.vm.provision "Bootstrap", type: "shell", privileged: false, path: "scripts/bootstrap.sh"
  config.vm.provision "apps/vim", type: "shell", privileged: false, path: "scripts/apps/vim.sh"
  config.vm.provision "apps/gui", type: "shell", privileged: false, path: "scripts/apps/gui.sh"
  config.vm.provision "fix VMWare tools", type: "shell", privileged: true, inline: $fix_vmware_tools_script
end
