### windows 

1.跳转到当前驱动器的根目录 

cd [当前驱动器盘符]:\    例如： cd c:\ 

或者更简单的   cd\ 

2.跳转到当前驱动器的其他文件夹 

以C盘下的WINDOWS文件夹为例  输入：cd C:\WINDOWS 

3.跳转到其他驱动器 

以从C盘跳转到D盘为例 在任意目录下直接输入：  D: 

4.跳转到其他驱动器的其他文件夹 

假设当前在C盘，要跳转到E的software目录    cd /d e:\software 

### windows import opencv 

路径必须是双斜杠 `\\`

```
import sys
sys.path.append('D:\\opencv249\\opencv\\build\\python\\2.7\\x64')
```