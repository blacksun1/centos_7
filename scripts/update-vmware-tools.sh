sudo mkdir /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
sudo cp /mnt/cdrom/VMwareTools-10.0.5-3228253.tar.gz /tmp/
cd /tmp
tar -zxvf VMwareTools-10.0.5-3228253.tar.gz
cd vmware-tools-distrib
sudo ./vmware-install.pl
