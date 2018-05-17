---
title: git patch basic usage
comments: true
categories: [dev]
tags: [git, helm]
date: 2014-07-07 14:08:18
---

git-am is a command that allows you to apply patches to the current branch.


```
1.1、两个commit间的修改（包含两个commit）
git format-patch <r1>..<r2>
如：
git format-patch d77aaac74845435744c49ae65511d9e1be79ed5c...046ee8f8423302f5070ca81b4e246516e919cd7a -o patch
　1.2、单个commit
git format-patch -1 <r1>
　1.3、从某commit以来的修改（不包含该commit）
git format-patch <r1>


3.1、 检查patch文件
git apply --stat 0001-minor-fix.patch
3.2、 查看是否能应用成功
git apply --check 0001-minor-fix.patch
4、应用patch
git am -s < 0001-minor-fix.patch


```


https://git-scm.com/docs/git-format-patch
https://stackoverflow.com/questions/6658313/generate-a-git-patch-for-a-specific-commit
