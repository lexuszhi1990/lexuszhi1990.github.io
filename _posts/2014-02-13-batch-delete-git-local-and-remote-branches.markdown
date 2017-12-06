---
layout: post
title: "Batch delete git local and remote branches"
date: 2014-02-13 11:58:48 +0800
comments: true
categories: [dev, git, branch]
---

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
