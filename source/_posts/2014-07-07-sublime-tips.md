---
title: sublime tips
comments: true
categories:
  - dev
  - sublime
date: 2014-07-07 14:08:18
tags:
---


sublime是一款非常好用的编辑器，上手简单，功能强大。

### official web: [Sublime](http://www.sublimetext.com)

<!-- more -->

### Keyboard Shortcuts for OSX

- [Keyboard Shortcuts](http://docs.sublimetext.info/en/latest/reference/keyboard_shortcuts_osx.html#keyboard-shortcuts-osx)
- [Lucifr ShortCuts](http://lucifr.com/2011/09/10/sublime-text-2-useful-shortcuts/)

打开`Preferences - Keybindings-User`，即可编辑自己的快捷键
`{ "keys": ["super+="], "command": "reindent" }`

All Shortcuts都在`Preferences - Keybindings-Default`中找到。

####打开/前往

- ⌘T   前往文件
- ⌘⌃P  前往项目
- ⌘R   前往 method
- ⌘⇧P  命令提示
- ⌃G   前往行
- ⌘KB  开关侧栏
- ⌃ `  python 控制台
- ^ B  执行脚本结果，并在控制preprew台输出
- ⌘⇧N  新建窗口

####编辑

- ⌘L   选择行 (重复按下将下一行加入选择)
- ⌘D   选择词 (重复按下时多重选择相同的词进行多重编辑)
- ⌃⇧M  选择括号内的内容
- ⌘⇧↩  在当前行前插入新行
- ⌘↩   在当前行后插入新行
- ⌃⇧K  删除行
- ⌘KK  从光标处删除至行尾
- ⌘K⌫  从光标处删除至行首
- ⌘⇧D  复制(多)行
- ⌘J   合并(多)行
- ⌘KU  改为大写
- ⌘KL  改为小写
- ⌘ /  注释
- ⌘⌥ /   块注释
- ⌘Y   恢复或重复
- ⌘⇧V  粘贴并自动缩进
- ⌃ space  自动完成(重复按下选择下一个提示)
- ⌃M   跳转至对应的括号
- ⌘U   软撤销（可撤销光标移动）
- ⌘⇧U  软重做（可重做光标移动）-
- ⌘⇧A  选择标签内的内容
- ⌘⌥ .   闭合当前标签

####查找/替换

- ⌘F   查找
- ⌘⌥F  替换
- ⌘⌥G  查找下一个符合当前所选的内容
- ⌘⌃G  查找所有符合当前所选的内容进行多重编辑
- ⌘⇧F  在所有打开的文件中进行查找
- 拆分窗口/标签页
- ⌘⌥1  单列
- ⌘⌥2  双列
- ⌘⌥5  网格 (4组)
- ⌃[1,2,3,4]   焦点移动至相应组
- ⌃⇧[1,2,3,4]  将当前文件移动至相应组
- ⌘[1,2,3…]  选择相应标签页
- 书签
- ⌘F2  添加/去除书签
- F2   下一个书签
- ⇧F2  前一个书签
- ⌘⇧F2   清除书签

####标记

- ⌘K space   设置标记
- ⌘KW  从光标位置删除至标记
- ⌘KA  从光标位置选择至标记
- ⌘KG  清除标记

###Package Control

1. enter `Control + ` and output console and input

`import urllib2,os; pf='Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler( ))); open( os.path.join( ipp, pf), 'wb' ).write( urllib2.urlopen( 'http://sublime.wbond.net/' +pf.replace( ' ','%20' )).read()); print( 'Please restart Sublime Text to finish installation')`

2. install Packages

- [Basic usage](http://lucifr.com/2011/08/31/sublime-text-2-tricks-and-tips/)

- [10 top packages](http://www.henriquebarroso.com/my-top-10sublime-2-plugins/)

- [Alignment, BeautifyRuby, Emmet, Git, Gitgutter, RailsRelatedFiles, SublimeRailsNav, SublimeLinter]

###link for mac###

`ln -s "/Applications/Sublime Text app/Contents/SharedSupport/bin/subl" ~/bin/subl`

### user settings

{
  "color_scheme": "Packages/Color Scheme - Default/Monokai Bright.tmTheme",
  "dictionary": "Packages/Language - English/en_US.dic",
  "ensure_newline_at_eof_on_save": true,
  "font_size": 15.0,
  "ignored_packages":
  [
    "Vintage",
    "GBK Encoding Support",
    "SublimeCodeIntel"
  ],
  "spell_check": true,
  "tab_size": 2,
  "translate_tabs_to_spaces": true,
  "word_wrap": true
}

### 个人感触

我也是用vim开发做了两年，主要是做C开发。用到Macbook之后便开始使用sublime. 比较大的感触就是用sublime开发，尤其是在查找方面顺手了很多。

我想现在一个比较成熟的编辑器有这几点比较重要。
1. 流畅的界面和简单上手的操作
2. 简单的package安装和配置
3. 强大的社区
4. 最好是免费

vim有很多优秀的设计的地方。它对于每个按键都有特定得功能。十分符合unix的kiss原则。把这些简单的命令组合起来则可以完成很复杂的功能。 但对于新手，熟悉键位并找到合适的编辑配置，周期较长。更有的懒人不愿意去记这些命令，sublime的一个ctrl+shift+p只要记住这个命令，便可以呼出想要的执行命令了。
但vim和操作系统的亲缘性是它有着跨平台的优势，随便ssh到一个server上去，操起vi 便可以开始hack了。
