#!/bin/bash

# Change gain to 128
v4l2-ctl -d /dev/video0 -c gain=128

# Change power line frequeency to 50Hz
v4l2-ctl -d /dev/video0 -c power_line_frequency=1

# Drop exposure to the lowest level
v4l2-ctl -d /dev/video0 -c exposure_auto=1

# Set absolute exposure to 156 to prevent framedrops
v4l2-ctl -d /dev/video0 -c exposure_absolute=156

# Disable auto focus
v4l2-ctl -d /dev/video0 -c focus_auto=0

##Set the C920 cam to H264 encoding with 30fps
v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1
