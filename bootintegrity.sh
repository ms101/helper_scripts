#!/bin/bash
# simple manual integrity check for /boot partition with find or dd
# 1. hash all files in /boot
# 2. check if hash is different to last check (value stored in textfile)
# 3. write new value to textfile
# usage:
#	script.sh 		# runs the checks
#	script.sh reset		# deletes textfile

method=find			# find oder dd
bootpart=/dev/sdb1		# /boot partition
textfile=~/skripte/bootintegrity.${method}.sha256


if [[ "$1" == "reset" ]]; then
	rm "$textfile"
	echo "[*] textfile deleted"
	exit
fi

echo "[*] sha256 hash of /boot or its files via $method:"
if [[ "$method" == "dd" ]]; then
	NEU=$(sudo dd if=$bootpart bs=1K count=1 | sha256sum)
else
	NEU=$(find /boot -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum)
fi
echo "$NEU"
echo ""

if [ -f "$textfile" ]; then
	echo "[*] old hash:"
	ALT=$(cat "$textfile")
	echo $ALT
fi

# check diff
if [[ -z $ALT ]]; then
	echo "$NEU" > "$textfile"
	echo "[*] no textfile found containing old hash"
	exit
fi

if [[ "$ALT" == "$NEU" ]]; then
	echo ""
	echo "[*] OK"
	echo "$NEU" > "$textfile"
else
	echo ""
	echo -e "\t+++++++++++++++++++++++++++++"
	echo -e "\t[!] HASHES ARE DIFFERENT! [!]"
	echo -e "\t+++++++++++++++++++++++++++++"
	echo ""
	echo "textfile has not been overwritten with new hash value ($textfile)"
fi
