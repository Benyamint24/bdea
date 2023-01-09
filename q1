#!/bin/bash

# Resize the partition to fill the entire block device
resize2fs /dev/<block device>

echo "Partition resized successfully"


#save as resize_par.sh

sudo chmod +x resize_par.sh

#Add script to the list of startup scripts for the virtual machine
sudo vim /etc/rc.local

/path/to/resize_partition.sh &
exit 0

#Reboot
sudo reboot

