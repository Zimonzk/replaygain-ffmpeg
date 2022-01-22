#!/bin/bash

shopt -s extglob
for a in *.@(mp3|MP3)
do
	echo -e "$a"
	#analyze replaygain
	out=$(ffmpeg -y -i "$a" -af replaygain trash.mp3 2>&1)
	#echo -e "$out" | tail -n 2
	#extract track gain and peak from ffmpeg output
	gain=$(echo -e "$out" | grep -oP '(?<=track_gain = ).*(?=dB)' | tr -d '[:space:]' | tr '+' ' ')
	peak=$(echo -e "$out" | grep -oP '(?<=track_peak = ).*(?=\b)' | tr -d '[:space:]')
	echo -e gain "$gain"
	echo -e peak "$peak"
	#rename file because ffmpeg can't edit in-place
	mv "$a" tmp-d5G2-"$a"
	#insert tags for track gain and peak
	ffmpeg -n -i tmp-d5G2-"$a" -acodec copy -metadata REPLAYGAIN_TRACK_GAIN="$gain" -metadata REPLAYGAIN_TRACK_PEAK="$peak" "$a"
	rm tmp-d5G2-"$a"
done
rm trash.mp3
shopt -u extglob
