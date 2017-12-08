---
title: Batch delete git local and remote branches
comments: true
categories:
  - dev
  - git
  - branch
date: 2014-02-13 11:58:48
tags:
---


使用 git-workflow 开发项目过程中，往往会出现很多已经合并的分支，一个一个删除往往很麻烦，于是用了一个sh命令来删除本地的合并分支和远程分支。

<!-- more -->

### delete the local branches

in `~/.bash_profile` add these aliases

``` sh
alias 'git-delete-merged-branches'='git branch | grep -v "\*" | grep -v "master"| grep -v "develop" | xargs -n 1 git branch -d'

alias 'git-delete-all-branches'='git branch | grep -v "\*" | grep -v "master"| grep -v "develop" | xargs -n 1 git branch -D'
```

### delete the remote braches use ruby

<!-- more -->

in `irb` or `pry`

```
# get the merged branched from remote
remote_merged_branches= `git branch -r --merged`.split("\n").map(&:strip).reject {|b| b =~ /(master|develop)/}

remote_merged_branches.each do |b|
  remote, branch = b.split(/\//)
  `git push #{remote} :#{branch}`
end
```
