# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml' # STEP ONE, REQUIRE YAML!
configFile = File.open('workstation.config', 'r')
workstation_config = YAML.load(configFile.read)

# KERNEL UPGRADE
# https://www.vagrantup.com/docs/vmware/kernel-upgrade.html
$fix_vmware_tools_script = <<SCRIPT
sed -i.bak 's/answer AUTO_KMODS_ENABLED_ANSWER no/answer AUTO_KMODS_ENABLED_ANSWER yes/g' /etc/vmware-tools/locations
sed -i 's/answer AUTO_KMODS_ENABLED no/answer AUTO_KMODS_ENABLED yes/g' /etc/vmware-tools/locations
SCRIPT

# RESET PASSWORDS (Root and Vagrant)
# Arg0 = user
# Arg1 = password
$set_passwords = <<SCRIPT
echo Setting password for $1
echo "$1:$2" | chpasswd
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = 'puppetlabs/centos-7.0-64-puppet'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "vmware_fusion" do |vw|
    vw.gui = true
    vw.vmx['memsize'] = "#{workstation_config['memory']}"
    vw.vmx['numvcpus'] = "#{workstation_config['cpus']}"
    vw.vmx['svga.vramSize'] = '20971520'
    vw.vmx['svga.numDisplays'] = "#{workstation_config['monitors']}"
    vw.vmx['mks.enable3d'] = "#{workstation_config['enable3d'] ? 'TRUE' : 'FALSE'}"
  end

  config.vm.provider "virtualbox" do |vb|
    # Video card memory
    vb.customize ['modifyvm', :id, '--vram', '128']
    vb.customize ['modifyvm', :id, '--monitorcount', workstation_config['monitors']]
    vb.customize ['modifyvm', :id, '--accelerate3d', workstation_config['enable3d'] ? 'on' : 'off']

    # Name
    vb.name = workstation_config['vmName']

    # Customize the amount of memory on the VM: This is customised for a
    # GUI workstation
    vb.gui = true
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"] # "hosttoguest" | "bidirectional"
    vb.memory = workstation_config['memory']
    vb.cpus = workstation_config['cpus']

    # Required for using more than 1 cpu. Turn it off if just using one.
    vb.customize ["modifyvm", :id, "--ioapic", workstation_config['cpus'] > 1 ? "on" : "off"]
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--monitorcount", "#{workstation_config['monitors']}"]
    # Acceleration does not work on Linux
    vb.customize ["modifyvm", :id, "--accelerate2dvideo", "off"]
    # vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
    vb.customize ['modifyvm', :id, '--accelerate3d', workstation_config['enable3d'] ? 'on' : 'off']
    if RUBY_PLATFORM =~ /darwin/
      vb.customize ["modifyvm", :id, '--audio', 'coreaudio', '--audiocontroller', 'hda'] # choices: hda sb16 ac97
    elsif RUBY_PLATFORM =~ /mingw|mswin|bccwin|cygwin|emx/
      vb.customize ["modifyvm", :id, '--audio', 'dsound', '--audiocontroller', 'ac97']
    end

  end

  config.vm.provision "SetPasswordVagrant", type: "shell", privileged: true, inline: $set_passwords, args: ["vagrant", workstation_config['password']]
  config.vm.provision "SetPasswordRoot", type: "shell", privileged: true, inline: $set_passwords, args: ["root", workstation_config['rootPassword']]
  config.vm.provision "bootstrap", type: "shell", privileged: false, path: "scripts/bootstrap.sh"
  config.vm.provision "apps/zsh", type: "shell", privileged: false, path: "scripts/apps/zsh.sh"
  config.vm.provision "apps/ohmyzsh", type: "shell", privileged: false, path: "scripts/apps/ohmyzsh.sh"
  config.vm.provision "apps/vim", type: "shell", privileged: false, path: "scripts/apps/vim.sh"
  config.vm.provision "apps/git", type: "shell", privileged: false, path: "scripts/apps/git.sh"
  config.vm.provision "apps/gui", type: "shell", privileged: false, path: "scripts/apps/gui.sh"
  config.vm.provision "fix VMWare tools", type: "shell", privileged: true, inline: $fix_vmware_tools_script
  config.vm.provision "apps/sublimetext", type: "shell", privileged: false, path: "scripts/apps/sublimetext.sh"
  config.vm.provision "apps/nvm", type: "shell", privileged: false, path: "scripts/apps/nvm.sh"
end
