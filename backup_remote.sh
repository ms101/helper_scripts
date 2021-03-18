#!/bin/bash
# backup script:
#   compress, encrypt, upload and delete

# prerequisites
DATE=$(date +%Y-%m-%d)
SOURCE="file1 file2 .config/bla"
NAME="xy-backup-"	# no white-spaces
cd ~

# compress
echo "[*] compressing data..."
if tar -czf $NAME$DATE.tgz $SOURCE; then
	echo "[*] compressing done"
else
	echo "[!] compression failed!"
	exit 1
fi

# encrypt
echo "[*] encrypting data..."
if gpg2 --batch --yes --passphrase=secret -c $NAME$DATE.tgz; then
	echo "[*] encryption done"
	rm $NAME$DATE.tgz
else
	echo "[!] encryption failed!"
	exit 1
fi

# copy via scp
echo "[*] copying to server..."
if scp $NAME$DATE.tgz.gpg user@host:/dir/; then
	echo "[*] scp done!"
	echo "[*] backup succeeded!"
#	rm $NAME$DATE.tgz.gpg
else
	echo "[!] scp failed!"
	exit 1
fi
