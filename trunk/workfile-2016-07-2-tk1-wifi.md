### sshfs
http://distrustsimplicity.net/articles/nvidia-jetson-tk1-wifi/

http://elinux.org/Jetson/Network_Adapters

http://elinux.org/Jetson_TK1

http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=3&PNid=48&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true#2317

http://blog.csdn.net/choclover/article/details/6886357


### custom config for tk1

in ~/.bashrc

```sh
export PATH=/usr/local/cuda-6.5/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LD_LIBRARY_PATH=/usr/local/cuda-6.5/lib:
export __GL_PERFMON_MODE=1

if [ -f ~/.custom_config ]; then
    . ~/.custom_config
fi
```

in ~/.custom_config

```sh
# custom config here...

export PYTHONPATH=/usr/lib/python2.7/dist-packages:$PYTHONPATH

# config PS1
# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
} 
# change PS1 like 'david octopress (master) $'
export PS1="\u@\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

alias ..='cd ..'

```