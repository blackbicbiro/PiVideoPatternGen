#!/bin/bash
# Script to start gstreamer and disbale blinking curose when running


echo "gstreamer player service starting"


function shutdown_handler()
{
        echo "Gstreamer service shutting down" 
        echo 1 > /sys/class/graphics/fbcon/cursor_blink         # enable blinking curose again on exit
        dd if=/dev/zero of=/dev/fb0 > /dev/null 2>&1            # Clear frame buffer to blank on exit
        echo 'gstreamer playing requested to shutdown'
        exit 0
}




# trapping the SIGTERM signal
trap shutdown_handler SIGTERM





#disable blinking cursor
echo 0 > /sys/class/graphics/fbcon/cursor_blink

gst-launch-1.0 \
        videotestsrc is-live=true pattern=19 \
        ! video/x-raw,width=1920, height=1080, framerate=60/1 \
        ! textoverlay text="NO RECEIVED SIGNAL" valignment=center shaded-background=false draw-outline=true draw-shadow=false color=4278190080 font-desc="Sans, 25" \
        ! clockoverlay color=4278190080 valignment=top time-format="%H:%M:%S (GMT)" halignment=center draw-shadow=false shaded-background=false font-desc="Sans, 25" \
        ! fbdevsink

