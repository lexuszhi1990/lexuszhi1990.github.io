nvidia-smi 查看GPU数量和运行状态

http://www.robots.ox.ac.uk/~vgg/research/very_deep/

https://gist.github.com/ksimonyan/3785162f95cd2d5fee77

[ubuntu安装和卸载软件命令](http://blog.163.com/angus007@126/blog/static/5070795120085324549941/)


[出现Press ENTER or type command to continue的原因](http://blog.csdn.net/cheneykids/article/details/8903283 "出现Press ENTER or type command to continue的原因")

http://blog.csdn.net/fyh2003/article/details/6995499

G-Code

M84: Stop idle hold 
Example: M84 
Stop the idle hold on all axis and extruder. In some cases the idle hold causes annoying noises, which can be stopped by disabling the hold. Be aware that by disabling idle hold during printing, you will get quality issues. This is recommended only in between or after printjobs. 

停止ＩＤＬＥ，保持所有的轴及挤出器，有些情况下，ＩＤＬＥ会发生扰人的声音，通过解除锁定就可以消除。在打印过程中小心解除锁定，打印质量会受到影响，这个命令只在打印前或后推荐使用

M104:设置挤出机（热头）温度 
例如: M104 S190 
将挤出机的温度设置为190o
C 并将操作全归还给操作主机（控制PC)

M105: 获取温度 
Example: M105 
请求当前温度（单位：℃），温度将立即返回到控制程序 （T：挤出机 B：加热床） 例如，输出候会得到这样的答复 ok T:201 B:117  

M106: 打开风扇 
Example: M106 S127 打开风扇（半速） 
'S'表示 PWM值 (0-255). 可简单理解为 风扇有0-255级强度可选，其中 M106 S0 意味着风扇将被关掉。

M107: 关闭风扇 
不推荐. 请用M106 S0 代替.

M108: 设置挤出机速度 
设置挤出机电机的转速 (不推荐，请使用 M113)

M109 in Marlin, Sprinter固件 (ATmega port) 
设置挤出机温度，并等待. Example: M109 S185 