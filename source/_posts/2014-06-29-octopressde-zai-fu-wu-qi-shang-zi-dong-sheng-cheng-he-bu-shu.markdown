---
layout: post
title: "Octopress的在服务器上自动生成和部署"
date: 2014-06-29 15:36:52 +0800
comments: true
categories: [tech, octopress, deploy, git]
published: false
---

我的blog开始是用github page做的，但是天朝网络无规则抽风，访问太慢，经常10s无反应。所以觉得还是把blog部署到我的vps上面去。

考虑再三之后决定按照[这篇文章的方法](http://www.xiaozhou.net/octopress-auto-generate-and-deploy-2013-08-15.html)，让blog的生产和部署都再服务器上面自动完成。也就是说，我们只要把blog写好psuh到server上面，服务端上的Git Hooks脚本，在检测到客户端push过来的改动后，自动生成静态blog页面文件，并部署到Nginx配置的blog目录中。

### 服务器上面的配置

首先 ssh到server上面去

```sh

BLOG_DIR="$HOME/DAVID_BLOG"
mkdir $BLOG_DIR && cd $BLOG_DIR
mkdir blog.git work-dir  octopress

cd blog.git
git init --bare
git config core.bare false
git config core.worktree $BLOG_DIR/work-dir
git config receive.denyCurrentBranch ignore

cd hooks/

cat << EOF > post-receive
#!/bin/bash
GIT_WORK_TREE=$BLOG_DIR/work-dir git checkout -source
cd $BLOG_DIR/work-dir
source /etc/profile
rake generate
cp -r -f ./public/* $BLOG_DIR/octopress
EOF

chmod 755 post-receive
```

