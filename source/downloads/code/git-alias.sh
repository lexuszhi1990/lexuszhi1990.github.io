alias 'gs'='git status'
alias 'gb'='git branch'
alias 'gbr'='git branch -r'
alias 'gp'='git push'
alias 'gpull'='git pull'
alias 'gpo'='git pull origin'
alias 'ga'='git add . -p'
alias 'gi'='git commit -v'
alias 'gbd'='git branch -d'
alias 'gbD'='git branch -D'
alias 'gkb'='git checkout -b'
alias 'git-remotes'='git remote -v'
alias 'git-stash'='git stash'
alias 'git-stash-list'='git stash list'
alias 'git-stash-apply'='git stash apply'
alias 'git-stash-pop'='git stash pop'
alias 'git-stash-clear'='git stash clear'
alias 'git-develop-update'='git checkout develop && git pull origin develop'
alias 'git-master-update'='git checkout master && git pull origin master'
alias 'git-delete-merged-branches'='git branch | grep -v "\*" | grep -v "master"| grep -v "develop" | xargs -n 1 git branch -d'
alias 'git-delete-all-branches'='git branch | grep -v "\*" | grep -v "master"| grep -v "develop" | xargs -n 1 git branch -D'

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
