---
layout: post
title: "usefull alias"
date: 2014-02-07 20:39:47 +0800
comments: true
published: true
categories: [dev, bash]
---

### Git Alias

``` bash

alias 'gs'='git status'
alias 'gb'='git branch'
alias 'gbr'='git branch -r'
alias 'gp'='git push'
alias 'gpull'='git pull'
alias 'gpo'='git pull origin'
alias 'gpm'='git pull origin master'
alias 'ga'='git add . -p'
alias 'gi'='git commit -v'
alias 'gbd'='git branch -d'
alias 'gbD'='git branch -D'
alias 'gkb'='git checkout -b'
alias 'git-remotes'='git remote -v'
alias 'git-throw'='git reset --soft HEAD^'
alias 'git-stash'='git stash'
alias 'git-stash-list'='git stash list'
alias 'git-stash-apply'='git stash apply'
alias 'git-stash-pop'='git stash pop'
alias 'git-stash-clear'='git stash clear'
alias 'git-develop-update'='git checkout develop && git pull origin develop'
alias 'git-master-update'='git checkout master && git pull origin master'
alias 'git-upstream-update'='git checkout upstream_master && git pull upstream master'
alias 'git-delete-merged-branches'='git branch --merged | grep -v "\*" | grep -v "master"| grep -v "develop" | xargs -n 1 git branch -d'
alias 'git-delete-all-branches'='git branch | grep -v "\*" | grep -v "master"| grep -v "develop" | xargs -n 1 git branch -D'
alias 'git-fetch-prune'='git fetch --prune'
function git-fetch-remote { git fetch origin :$1; git co $1; gpo $1;  }

function String.parameterize (){
  ruby -e "require 'active_support/core_ext/string'; puts '$1'.parameterize;"
}

function git-new-branch {
  git checkout develop
  String.parameterize "$1" > __tmp__
  cat __tmp__ |xargs -L1 git checkout -b
  rm __tmp__
}

function git-checkout-remote { git checkout -b $1 origin/$1; };

```


### use git branch for Directory

```
# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# change PS1 like 'david octopress (master) $'
export PS1="\u \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $"
```

<!-- more -->

### Rails Alias

```
# rails
alias pro='RAILS_ENV=production'
alias bi="bundle install"
alias be="bundle exec"
alias rs="be rails s"
alias brs="be rspec"

# tool tips
alias g-s="grunt server --force"
alias bo="bundle open"
alias boi="bower install"
alias zs="zeus start"
alias zc="zeus c"
alias rc="be rails c"

# rails gegerators
alias rg="be rails g"
alias rails-g-migration="rg migration"
alias rails-g-controller='rg controller'
alias rails-g-model='rg model'
alias rails-g-scaffold='rg scaffold'

# rake tasks
alias re="be rake"
alias rr="be rake routes"
alias rake-migrate="re db:migrate"
alias rake-migrate-redo="re db:migrate:redo"
alias rake-rollback="re db:rollback"
alias rake-create="re db:create"
alias rake-drop="re db:drop"
alias rake-seed-fu="re db:seed_fu"
alias rake-time-zones="re time:zones:all"
alias rake-assets-precomplie="RAILS_ENV=production rake assets:precompile"
alias rake-assets-clean="rake assets:clean"

# backbone generators
alias backbone-model="rg backbone:model"
alias backbone-router="rg backbone:router"
alias backbone-scaffold="rg backbone:scaffold"

# rails servers
alias 3rs="rs 3000"
alias 4rs="rs 4000"
```


### Capistrano Alias

```
# deploy
alias cap-staging="cap staging deploy"
alias cap-staging-migrations="cap staging deploy:migrations"
alias cap-staging-rake="cap staging remote:rake"
alias cap-staging-console="cap staging remote:console"
alias cap-staging-database-update="cap staging update:database"
alias cap-staging-assets-update="cap staging update:shared_assets"
alias cap-staging-assets-remote-update="cap staging update:remote:shared_assets"
alias cap-staging-remote-tail-log='cap staging remote:tail_log'

alias cap-production="cap production deploy"
alias cap-production-migrations="cap production deploy:migrations"
alias cap-production-rake="cap production remote:rake"
alias cap-production-console="cap remote:console"
alias cap-production-database-update="cap production update:database"
alias cap-production-assets-update="cap production update:shared_assets"
alias cap-production-assets-remote-update="cap production update:remote:shared_assets"
alias cap-production-database-remote-update="cap production update_remote:database"
alias cap-production-remote-tail-log='cap production remote:tail_log'

```

### Heroku Alias

```
alias 'heroku-open'='heroku open'
alias 'heroku-log-tail'='heroku logs --tail'
alias 'heroku-push'='git push heroku master'
alias 'heroku-run'='heroku run'
alias 'heroku-db-migrate'='heroku run rake db:migrate'
alias 'heroku-db-seed-fu'='heroku run rake db:seed_fu'
alias 'heroku-console'='heroku run rails console'
alias 'heroku-deploy'='git-master-update && heroku-push'
alias 'heroku-deploy-migration'='heroku-deploy && heroku-db-migrate'
alias 'heroku-db-update'='rake heroku:update:database'
alias 'heroku-restart'='heroku restart -a #{your-app-name}'
```

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

# octopress deploy

```
alias 'octopress-deploy'='git push origin source && rake gen_deploy'
```
