export FBFONT=/usr/share/kbd/consolefonts/ter-216n.psf.gz

export PATH=$PATH:~/android-sdk-linux/tools
export PATH=$PATH:~/android-sdk-linux/platform-tools
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.cabal/bin

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then 
	exec startx
fi

alias ayayay="yay"
alias fim="devour fim"
alias zathura="devour zathura"
alias black="doas ratslap --modify F3 --colour black"
alias green="doas ratslap --modify F3 --colour green"
alias activate="source venv/bin/activate"

# Record mono alsa audio with ffmpeg
monorec() { ffmpeg -f alsa -channels 1 -i default $HOME/Music/`date +%Y%m%d_%H%M%S`.wav ; }

# Record stereo alsa audio with ecasound (mixes all inputs into a single stereo file)
stereorec() { ffmpeg -f alsa -channels 2 -i default $HOME/Music/`date +%Y%m%d_%H%M%S`.wav ; }

# Stereo recording with 50-50 panning
# ffmpeg -f alsa -thread_queue_size 1024 -i default -f alsa -thread_queue_size 1024 -i default \
#    #-c:a aac -ac 2 -af "pan=2c|c0=c0" left.wav \
#    -c:a aac -ac 2 -af "pan=2c|c1=c1" right.wav

# Record screen with one channel of alsa audio
screenrec() { ffmpeg -f x11grab -video_size 1600x900 -framerate 30 -thread_queue_size 1024 -i $DISPLAY -f alsa -thread_queue_size 1024 -i default -c:v libx264 -preset superfast -c:a aac -ac 1 $HOME/Videos/`date +%Y%m%d_%H%M%S`.mp4 ; }

# Record 30fps 1080p MJPEG webcam video with one channel of alsa audio
webcamrec() { ffmpeg -f v4l2 -framerate 30 -video_size 1920x1080 -thread_queue_size 1024 -c:v mjpeg -i /dev/video0 -f alsa -thread_queue_size 1024 -i default -preset superfast -c:a aac -ac 1 $HOME/Videos/`date +%Y%m%d_%H%M%S`.mov ; }

# Record 30fps 1080p MJPEG webcam video with one channel of alsa audio
webcamrec2() { ffmpeg -f v4l2 -framerate 30 -video_size 1920x1080 -thread_queue_size 1024 -c:v mjpeg -i /dev/video0 -f alsa -thread_queue_size 1024 -i default -preset superfast -c:a aac -channels 2 $HOME/Videos/`date +%Y%m%d_%H%M%S`.mov ; }

# Record screen without audio
screenrecnoaudio() { ffmpeg -f x11grab -video_size 1600x900 -framerate 30 -thread_queue_size 1024 -i $DISPLAY -c:v libx264 -preset superfast $HOME/Videos/`date +%Y%m%d_%H%M%S`.mp4 ; }

# Record 30fps 1080p MJPEG webcam video without audio
webcamrecnoaudio() { ffmpeg -f v4l2 -framerate 30 -video_size 1920x1080 -thread_queue_size 1024 -c:v mjpeg -i /dev/video0 -c:v copy -preset superfast $HOME/Videos/`date +%Y%m%d_%H%M%S`.mov ; }
