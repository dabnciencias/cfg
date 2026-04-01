#Goes in ~/
export ARXIV_DOWNLOAD_FOLDER="/home/dabn/Downloads/kobo/Doctorado/Leer/"
export FBFONT=/usr/share/kbd/consolefonts/ter-216n.psf.gz
export EDITOR=vim
export PATH="$PATH:/home/dabn/.local/bin"
export READER=zathura

alias activate="source venv/bin/activate"
alias adl="arxiv-dl"
alias bc="eva"
alias bib="pybibget"
alias brilliant="vim -p ~/Elm/alganim/src/DraggableVector.elm ~/Elm/alganim/src/PlaneCoordinates.elm"
alias bton="sudo rfkill block wlan && sudo rc-service bluetoothd start"
alias btoff="sudo rfkill unblock wlan && sudo rc-service bluetoothd stop"
alias btr="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage"
alias cat="bat"
alias dw="termdown -abs -c 900 2h -T 'deep work' -t 'rest time' --no-figlet"
alias ert="cd ~/Elm/beginning-elm/ && elm reactor"
alias grep="rg"
alias grupos="vim -p ~/AM/Notas/0.tex ~/AM/Notas/1.tex ~/AM/Notas/2.tex ~/AM/Notas/3.tex ~/AM/Notas/notasGrupos.tex ~/AM/Notas/pre.tex ~/AM/Notas/intro.tex -c ':tabn | :tabn | :tabn'"
alias kb="setxkbmap us altgr-intl"
alias ls="exa -alF"
alias ma="doas mount -a"
alias manim=".venv/bin/python -m manim" #using python project manager uv
alias ms="manim -psqh"                  #generate last frame
alias poweroff="doas poweroff"
alias reboot="doas reboot"
alias nts="vim -p ~/Downloads/kobo/Doctorado/Notes/misc.tex ~/Downloads/kobo/Doctorado/Notes/pre.tex ~/Downloads/kobo/Doctorado/Notes/additiveCategoryTheory.tex ~/Downloads/kobo/Doctorado/Notes/approximationTheory.tex ~/Downloads/kobo/Doctorado/Notes/purityTheory.tex ~/Downloads/kobo/Doctorado/Notes/siltingAndCosiltingTheory.tex ~/Downloads/kobo/Doctorado/Notes/mutationTheory.tex ~/.vim/UltiSnips/tex.snippets ~/Downloads/kobo/Doctorado/Notes/misc.bib ~/Downloads/kobo/Doctorado/Notes/misc.log -c ':tabn | :tabn | :tabn | :tabn | :tabn'"
alias s2p="scitopdf"
alias sbrc="source ~/.bashrc"
alias some="cd ~/dabnimations/SoME4; pixi shell"
alias sxiv="devour sxiv"
alias unblock="doas rfkill unblock wlan"
alias xournalpp="devour xournalpp"
alias zathura="devour zathura"

# Mount device with umask=000
mymount() { doas mount $1 $2 -o umask=000 ; }

#
lct() { vim -p ~/Downloads/kobo/Doctorado/Notes/$1/$1.tex ~/.vim/UltiSnips/tex.snippets ~/Downloads/kobo/Doctorado/Notes/misc.bib ~/Downloads/kobo/Doctorado/Notes/$1/$1Notes.log ; }
dft() { vim -p ~/Downloads/kobo/Doctorado/Drafts/$1/$1.tex ~/Downloads/kobo/Doctorado/Notes/pre.tex ~/.vim/UltiSnips/tex.snippets ~/Downloads/kobo/Doctorado/Notes/misc.bib ~/Downloads/kobo/Doctorado/Drafts/$1/$1.log ; }

# Change Logitech G300s mouse color
colour() { doas ratslap --modify F3 --colour $1 ; }

# Record pulse audio with ffmpeg (with number of channels as an argument)
audiorec() { ffmpeg -f pulse -channels $1 -i default $HOME/Music/`date +%Y%m%d_%H%M%S`.wav ; }

# Record video with ffmpeg
# --webcam and --screen options assume only one microphone is being used 2560x1080
videorec() {
    if [ $1 = "--screen" ]; then
        `ffmpeg -f x11grab -video_size 1366x768 -framerate 30 -thread_queue_size 1024 -i $DISPLAY -f pulse -thread_queue_size 1024 -channels 1 -i default -c:v libx264 -preset superfast -c:a aac -ac 2 $HOME/Videos/$(date +%Y%m%d_%H%M%S).mp4`
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

# set dual monitors
dual () {
    xrandr --output DP-1 --primary --left-of HDMI-1 --output HDMI-1 --auto
}

# set single monitor
single() {
    xrandr --output HDMI-1 --off
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
