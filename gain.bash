#!/bin/bash

shopt -s extglob
for a in *.@(mp3|MP3)
do
	echo -e "$a"
	out=$(ffmpeg -y -i "$a" -af replaygain trash.mp3 2>&1)
	#echo -e "$out" | tail -n 2
	gain=$(echo -e "$out" | grep -oP '(?<=track_gain = ).*(?=dB)' | tr -d '[:space:]' | tr '+' ' ')
	peak=$(echo -e "$out" | grep -oP '(?<=track_peak = ).*(?=\b)' | tr -d '[:space:]')
	echo -e gain "$gain"
	echo -e peak "$peak"
	mv "$a" tmp-d5G2-"$a"
	ffmpeg -n -i tmp-d5G2-"$a" -acodec copy -metadata REPLAYGAIN_TRACK_GAIN="$gain" -metadata REPLAYGAIN_TRACK_PEAK="$peak" "$a"
	rm tmp-d5G2-"$a"
done
rm trash.mp3
shopt -u extglob
