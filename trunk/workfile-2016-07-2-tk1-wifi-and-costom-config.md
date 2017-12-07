### update the jetson kern


https://devtalk.nvidia.com/default/topic/906018/jetson-tk1/-customkernel-the-grinch-21-3-4-for-jetson-tk1-developed/

Apply binaries:

`sudo ./apply_binaries.sh`

现在用一根micro USB线连接到开发板上，按下RECOVERY键不放开，然后按下RESET键，进入烧写模式, lsusb check the usb cable.

then 

`sudo ./flash.sh  jetson-tk1 mmcblk0p1`

referebces
---
- http://elinux.org/Jetson_TK1
- http://elinux.org/Jetson/Network_Adapters


### setup usb wifi

http://distrustsimplicity.net/articles/nvidia-jetson-tk1-wifi/


This can be seen in ifconfig or NetworkManager, via the command-line interface nmcli:

ubuntu@tegra-ubuntu:~$ nmcli dev
DEVICE     TYPE              STATE
eth0       802-3-ethernet    connected
wlan0      802-11-wireless   disconnected 

nmcli dev wifi connect <YOUR_SSID_HERE> password <YOUR_KEY_HERE>

these two links doesn't work...

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