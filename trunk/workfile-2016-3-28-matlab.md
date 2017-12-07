### matlab 使用

matlab可以不启动图形界面运行，比如
`matlab -nodesktop -nosplash`
或者

`matlab -nodisplay`

或者

`matlab -nojvm -nosplash`

matlab程序也可以在命令行里直接运行，只需要使用 -r 选项。比如运行当前目录下的example.m
`matlab  -nodesktop -nosplash -r example`

-nodesktop   启动jvm(Jave Virtual Machine)，不启动desktop，但help 界面，preferences界面等仍可通过cmdline 调出，即jvm启动但不启动desktop，可以启动其他显示；但是matlab不会在cmd history记录本次执行的命令

-nodisplay   启动jvm，不启动desktop，不启动任何显示相关，忽略任何DISPLAY 环境变量；即jvm启动但不能显示

-nojvm       不启动jvm，则与之相关的一切活动将无法进行，包括图形界面显示，help 界面，preferences界面等 即jvm不启动故不能显示

-nosplash    只是不显示启动时的log画面，jvm，desktop等正常启动

http://blog.sina.com.cn/s/blog_6bebbb2f0100w6h5.html

### matlab ^ 和 .^

数组的幂运算是 .^
矩阵的幂运算是 ^


### addpath

只是添加目录的话是：addpath('funcpath');
 
添加目录及其子目录是： addpath(genpath('funcpath/.'));