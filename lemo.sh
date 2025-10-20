#!/bin/sh

PANEL_FIFO="/tmp/panel-fifo"
DESKTOP_FIFO="/tmp/desktop-fifo"
font="GoMono Nerd Font:size=12"

rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

while true; do
    	desktop=$(xdotool get_desktop)
	echo 'W'$desktop
	sleep 0.5

done > "$PANEL_FIFO"  &

while true; do
    	time=$(date "+%I:%M%p")
    	echo 'T'$time
    	sleep 10 
    	
done > "$PANEL_FIFO" &

while true; do
    	bat=$(acpi -b | cut -d, -f2)
    	echo 'B'$bat
    	sleep 10 
    	
done > "$PANEL_FIFO" &

while read -r line < $PANEL_FIFO; do
    case $line in

    	W*)
        	workspace="${line#?}";;

        T*)
            	currtime="${line#?}";;

        B*)
                batperc="${line#?}";;
	esac
        echo "%{B#292D3E}%{F#876058} ${workspace} %{F#bab7b5}|%{F#6f7f71} ${currtime} %{F#bab7b5}|%{F#546780}${batperc}"

        wait
    	
done | lemonbar -f "$font" -b -g 190x40+10+10 -d -o -1
