#!/bin/sh
# convert wav files into mono raw ones
# for use with the radio music module by thonk.co.uk
# dependencies: sox and perls rename

# 2015-2038 wotwot.
# license cc-by-sa

# usage:
# cd into a folder with 16 bit 44.1 stereo wav files
# and
# sh $whereverthiswassavedto/convert-to-radio-music.sh
# this will convert all wav files into radio music format ready to go into a folder on a micro SD.
# after the program is run, the folders "mono normalized raw" will still be there.
# the folder "raw" then contains the file(s) for the RadioMusic sd card.
# the program might barf out when working on files with funny names (__fixme__)

# disclaimer: NO WARRANTY. if this program does something unexpected or worse,
# the author is not to be held responsible for any damages incurred.

for i in sox rename ; do
	test -x `which $i`
	err=$?
	if [ ! "$err" -eq 0 ] ; then
		echo "$0: cannot find $i"
		exit
	fi
done

for i in mono normalized raw ; do
	if [ ! -d "$i" ] ; then
		mkdir $i
	fi
done

# make monos
for i in *wav ; do
	sox "$i" -c 1 "mono/$i"
done

# normalise. feel free to comment this part (until # --) if you don't want it
cd mono

for i in *wav ; do
	sox "$i" --norm -t sox - silence 1 0.1 1% reverse | sox -t sox -b 16 - "../normalized/$i" silence 1 0.1 1% reverse
done

# make raw
cd ../normalized

# --

for i in *wav ; do
	sox "$i" -t raw -b 16 "../raw/$i"
done

cd ../raw

rename 's/.wav/.raw/g' *

