export FBFONT=/usr/share/kbd/consolefonts/ter-216n.psf.gz
export EDITOR=vim

alias activate="source venv/bin/activate"
alias bc="eva"
alias cat="bat"
alias fim="devour fim"
alias grep="rg"
#alias g++="g++ -std=c++11 -pedantic-errors -Wall -Weffc++ -Wextra -Wsign-conversion -Werror"
alias ls="exa -alF"
alias ma="doas mount -a"
alias poweroff="doas poweroff"
alias tesis="vim -p ~/ExTr/0.tex ~/ExTr/1.tex ~/ExTr/2.tex ~/ExTr/3.tex ~/ExTr/4.tex ~/ExTr/5.tex ~/ExTr/tesis.tex ~/ExTr/pre.tex ~/ExTr/intro.tex ~/ExTr/tesis.bib -c ':tabn | :tabn | :tabn | :tabn'"
alias reboot="doas reboot"
alias sbrc="source ~/.bashrc"
alias unblock="doas rfkill unblock wlan"
alias xournalpp="devour xournalpp"
alias zathura="devour zathura"

# Mount device with umask=000
mymount() { doas mount $1 $2 -o umask=000 ; }

# Change Logitech G300s mouse color
colour() { doas ratslap --modify F3 --colour $1 ; }

# Record pulse audio with ffmpeg (with number of channels as an argument)
audiorec() { ffmpeg -f pulse -channels $1 -i default $HOME/Music/`date +%Y%m%d_%H%M%S`.wav ; }

# Record video with ffmpeg
# --webcam and --screen options assume only one microphone is being used
videorec() {
    if [ $1 = "--screen" ]; then
        `ffmpeg -f x11grab -video_size 2560x1080 -framerate 30 -thread_queue_size 1024 -i $DISPLAY -f pulse -thread_queue_size 1024 -channels 1 -i default -c:v libx264 -preset superfast -c:a aac -ac 2 $HOME/Videos/$(date +%Y%m%d_%H%M%S).mp4`
    elif [ $1 = "--screen-no-audio" ]; then
        ` ffmpeg -f x11grab -video_size 2560x1080 -framerate 30 -thread_queue_size 1024 -i $DISPLAY -c:v libx264 -preset superfast $HOME/Videos/$(date +%Y%m%d_%H%M%S).mp4`
    elif [ $1 = "--webcam" ]; then
        `ffmpeg -f v4l2 -framerate 30 -video_size 1920x1080 -thread_queue_size 1024 -c:v mjpeg -i /dev/video0 -f pulse -thread_queue_size 1024 -channels 2 -i default -preset superfast -c:a aac $HOME/Videos/$(date +%Y%m%d_%H%M%S).mov`
    elif [ $1 = "--webcam-no-audio" ]; then
        `ffmpeg -f v4l2 -framerate 30 -video_size 1920x1080 -thread_queue_size 1024 -c:v mjpeg -i /dev/video0 -c:v copy -preset superfast $HOME/Videos/$(date +%Y%m%d_%H%M%S).mov`
    else 
        echo "Valid options are '--screen', '--screen-no-audio', '--webcam' and '--webcam-no-audio'."
    fi
}

videostream() {
    if [ $1 = "--screen" ]; then
        ffmpeg -re -f x11grab -i $DISPLAY -thread_queue_size 1024 -f pulse -thread_queue_size 1024 -channels 1 -i default -c:v libx264 -b:v 3500k -maxrate 3500k -bufsize 7000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 -ar 44100 -preset superfast -f flv $2 ; 
    elif [ $1 = "--webcam" ]; then
        ffmpeg -re -i /dev/video0 -f pulse -thread_queue_size 1024 -channels 2 -i default -c:v libx264 -b:v 3500k -maxrate 3500k -bufsize 7000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 -ar 44100 -preset superfast -f flv $2 ;
    fi
}

sl() { streamlink --player mpv https://twitch.tv/$1 best ; }
