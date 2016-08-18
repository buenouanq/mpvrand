#!/bin/bash

#$1 path/to/file OR --playlist=path/to/playlist (no spaces)
#$2 is how many rows/columns you want (be carful ;3)

#I have both this file and mpvrand.lua in ~/.config/mpv/ and have aliased mpvrand='~/.config/mpv/mpvrand.sh'

if [ -z $2 ]; then #checks if second argument was given
	rows=1 #defalts to single video if not
else
	rows=$2
fi

mpvr="mpv $1 --lua=~/.config/mpv/mpvrand.lua --no-config  --shuffle --loop=inf --no-border --no-audio --no-sub --screen=1 --panscan=1 --no-osc --speed=$3" #--no-terminal

z=$[ $rows**2 ] #how many instances of mpv you'll end up with

sw=1920 #native screen resolution
sh=1080

w=$[ $sw / $rows ] #resolution of each video
h=$[ $sh / $rows ]

x=0 #position on screen
y=0

while [ $z -gt 0 ]; do
	$mpvr '--geometry='$w'x'$h'+'$x'+'$y &
	x=$[ $[ $x + $w ] % $sw ]
	if [ $x -lt $w ]	
		then
		y=$[ $[ $y + $h ] % $sh ]
	fi
	z=$[ $z - 1 ]
	sleep 1
done
exit
