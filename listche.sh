#!/bin/bash
smartctlpath="/usr/sbin/smartctl"
HDDS="sda sdb"
email="user@mail.com"
filesdir="./"
for DEV in $HDDS
do
        realocated=$($smartctlpath -A /dev/$DEV | grep "Reallocated_Sector_Ct" | awk 'NF>1{print $NF}')
        poweron=$($smartctlpath -A /dev/$DEV | grep "Power_On_Hours" | awk 'NF>1{print $NF}')
        oldres=$(cat $filesdir/$DEV.txt | awk 'NR==1{print $1}')
        if [[ $realocated != $oldres ]]
        	then
        		echo -e $realocated ' \t '$poweron ' \t '$(date +%d.%B.%Y) >> $filesdir/$DEV.txt # && mail -s "New Reallocated Sector found in $DEV" $email < $filesdir/$DEV.txt
        	fi
done
