#!/bin/bash

SONG="$(mocp -i | head -n 2 | tail -n 1 | cut -c 7-)"
RUN=0
echo $RUN
if [ -z "$SONG" ] || [ ! -e "$SONG" ]; then
	echo "mocp is not currently running or is stopped"
	exit
fi
ffmpeg -y -i "$SONG" /tmp/now_playing.jpg
sxiv -b -s f /tmp/now_playing.jpg &
PID=$(echo $!)

while [[ "$RUN" == "0" ]]; do
	if [[ $SONG != "$(mocp -i | head -n 2 | tail -n 1 | cut -c 7-)" ]]; then
		SONG="$(mocp -i | head -n 2 | tail -n 1 | cut -c 7-)"
		ffmpeg -y -i "$SONG" /tmp/now_playing.jpg &
	fi
	sleep 1
	RUN=$(ps --pid $PID; echo $?)
	RUN=$(echo $RUN | rev | cut -c 1)
done
