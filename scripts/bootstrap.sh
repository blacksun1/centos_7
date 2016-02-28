function disableInitialSetupText {
	echo 'Make sure the initial-setup-text service is totally disabled. We don''t want it halting the system for no reason'
	sudo systemctl disable initial-setup-text
}

function setTimezone {
	echo "Set the timezone to $1"
	sudo timedatectl set-timezone $1
}

function yumUpdate {
	echo 'Update all installed yum packages'
	sudo yum update -y
}

function addEpelRepository {
	echo "Adding Extra Packages for Enterprise Linux (EPEL) repository"
	sudo yum -y install epel-release && \
		sudo sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo # for another way, change to [enabled=0] and use it only when needed

	# sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo # set [priority=5]
	# yum --enablerepo=epel install [Package] # if [enabled=0], input a command
}

disableInitialSetupText
setTimezone 'Europe/London'
yumUpdate
addEpelRepository
