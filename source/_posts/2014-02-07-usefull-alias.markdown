---
layout: post
title: "usefull alias"
date: 2014-02-07 20:39:47 +0800
comments: true
draft: true
categories: [tech, bash ]
---

### Git Alias
{% include_code lang:bash git-alias.sh  %}

### use git branch for Directory

```
# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# change PS1 like 'david octopress (master) $'
export PS1="\u \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $"
```

### Rails Alias

{% include_code lang:bash rails-alias.sh  %}


### Capistrano Alias

{% include_code lang:bash rails-alias.sh  %}

### file direction
```
alias ..="cd .."
alias o="open ."
```

### refresh bashrc
```
alias 'fb'='source ~/.bash_profile'
```

### edit the `~/.bashrc`
```
alias 'en'='vim ~/.bashrc'
```

### rsync usage
```
alias 'rsync-files'="rsync -avrt --recursive --times --rsh=ssh --compress --human-readable --progress --delete user@server:/var/www/your-dir/public/ ~/your-dir/public/"

```

### sublime alias
```
alias 'st'='sublime'

# edit the snipets
alias 'st-snippets'='st Library/Application\ Support/Sublime\ Text\ 2/Packages/User/'
```

### create http server by ruby
```
alias ruby-httpd='open http://localhost:5000; ruby -run -e httpd . -p 5000'
```

### open Chrome with out security
```
alias 'chrome'='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias 'chrome-unsafe'='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --disable-web-security &'
```

