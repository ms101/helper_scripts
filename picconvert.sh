#!/bin/bash
# convert all JPGs in a directory to defined width and quality
# dependency: ImageMagick

width=3000
q=70

# argument given?
if [ $# -lt 1 ]
then
   echo "Usage: $0 [path to JPGs]"
   echo "Converts all JPGs in path to ${width} px width and q=${q} %"
   exit
fi

# load JPGs & convert
for jpg in "$1"/*
do
	ext="${jpg##*.}"

	if ([ $ext == "jpg" ] || [ $ext == "JPG" ])
	then
		magick "$jpg" -resize $width -quality $q "$jpg"
		echo "[*] $jpg converted"
	else
		echo "[!] $jpg is not a JPG"
	fi
done
