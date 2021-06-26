export FBFONT=/usr/share/kbd/consolefonts/ter-216n.psf.gz

alias activate="source venv/bin/activate"
alias ayayay="yay"
alias fim="devour fim"
alias mountall="sudo mount -a"
alias poweroff="doas poweroff"
alias reboot="doas reboot"
alias unblock="doas rfkill unblock wlan"
alias zathura="devour zathura"

# Mount device with umask=000
mymount() { doas mount $1 $2 -o umask=000 ; }

# Change Logitech G300s mouse color
colour() { doas ratslap --modify F3 --colour $1 ; }

# Record alsa audio with ffmpeg (with number of channels as an argument)
audiorec() { ffmpeg -f alsa -channels $1 -i default $HOME/Music/`date +%Y%m%d_%H%M%S`.wav ; }

# Record video with ffmpeg
# --webcam and --screen options assume only one microphone is being used
videorec() {
    if [ $1 = "--screen" ]; then
        `ffmpeg -f x11grab -video_size 1600x900 -framerate 30 -thread_queue_size 1024 -i $DISPLAY -f alsa -thread_queue_size 1024 -channels 1 -i default -c:v libx264 -preset superfast -c:a aac -ac 2 $HOME/Videos/$(date +%Y%m%d_%H%M%S).mp4`
    elif [ $1 = "--screen --no-audio" ]; then
        ` ffmpeg -f x11grab -video_size 1600x900 -framerate 30 -thread_queue_size 1024 -i $DISPLAY -c:v libx264 -preset superfast $HOME/Videos/$(date +%Y%m%d_%H%M%S).mp4`
    elif [ $1 = "--webcam" ]; then
        `ffmpeg -f v4l2 -framerate 30 -video_size 1920x1080 -thread_queue_size 1024 -c:v mjpeg -i /dev/video0 -f alsa -thread_queue_size 1024 -channels 2 -i default -preset superfast -c:a aac -channels 2 $HOME/Videos/$(date +%Y%m%d_%H%M%S).mov`
    elif [ $1 = "--webcam --no-audio" ]; then
        `ffmpeg -f v4l2 -framerate 30 -video_size 1920x1080 -thread_queue_size 1024 -c:v mjpeg -i /dev/video0 -c:v copy -preset superfast $HOME/Videos/$(date +%Y%m%d_%H%M%S).mov`
    else 
        echo "Valid options are '--screen', '--screen --no-audio', '--webcam' and '--webcam --no-audio'."
    fi
}
