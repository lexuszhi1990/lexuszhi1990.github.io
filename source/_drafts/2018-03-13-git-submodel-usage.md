---
title: git submodule basic usage
comments: true
categories: [dev]
tags: [git]
date: 2014-07-07 14:08:18
---


### 添加子仓库

`$ git submodule add -b master <仓库地址> <本地路径>`

添加成功后，在父仓库根目录增加了.gitmodule文件。

```
[submodule "repo"]
    path = lib
    url = ssh://your-url/repo.git
```


### 检出(checkout)

克隆一个包含子仓库的仓库目录，并不会clone下子仓库的文件，只是会克隆下.gitmodule描述文件，需要进一步克隆子仓库文件。

```
// 初始化本地配置文件
$ git submoudle init

// 检出父仓库列出的commit
$ git submodule update
```

### 删除子仓库

```
old_model="ps-lite"
git config -f .git/config --remove-section "submodule.${old_model}"
git config -f .gitmodules --remove-section "submodule.${old_model}"
git add .gitmodules
git commit -m "Removed ${old_model}"
git rm --cached "${old_model}"
rm -rf "${old_model}"              ## remove src (optional)
rm -rf ".git/modules/${old_model}" ## cleanup gitdir (optional housekeeping)
```

### update and edit

You'll need to run a special submodule initialize command (i.e. after cloning the main repository) to fetch the code for the first time:

`git submodule update --init`

Now, git uses the update command to also fetch and apply updates, but this time the arguments are slightly different:
`git submodule update --remote`

references
----------
- [How to remove a submodule in Git](https://forum.freecodecamp.org/t/how-to-remove-a-submodule-in-git/13228
)
