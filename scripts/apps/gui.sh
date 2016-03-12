echo Installing GUI
# TODO: Please see http://unix.stackexchange.com/questions/181503/how-to-install-desktop-environments-on-centos-7

function installGuiBasics {
	echo 'Installing GUI Basics'
	sudo yum groupinstall -y 'X Window System'
	# yum groupinstall 'GNOME Desktop Environment'
}

function installCinamonGUI {
	echo 'Installing Cinnamon'
	sudo yum --enablerepo=epel -y install cinnamon*
	echo "Making Cinnamon the default Window Manager"
	echo "exec /usr/bin/cinnamon-session" >> ~/.xinitrc
}

function installServerWithGUI {
	echo 'Installing the group ''Server with GUI'''
	sudo yum -y groupinstall 'Server with GUI'
}

function reinstallOpenVMWareTools {
	sudo yum install -y open-vm-tools open-vm-tools-desktop open-vm-tools-devel
}

function setTargetToGraphical {
	sudo systemctl set-default graphical.target
}

# installGuiBasics
installServerWithGUI
reinstallOpenVMWareTools
installCinamonGUI
setTargetToGraphical