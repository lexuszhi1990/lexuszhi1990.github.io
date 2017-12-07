

### basic install

`$ sudo apt-get install -y git tmux zsh vim`

`$ pip install --upgrade pip`

### oh my zsh
https://github.com/robbyrussell/oh-my-zsh

1. Clone the repository:
  `$ git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh`
2. Optionally, backup your existing ~/.zshrc file:

  `$ cp ~/.zshrc ~/.zshrc.orig`
3. Create a new zsh configuration file

  You can create a new zsh config file by copying the template that we have included for you.

  `$ cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc`
4. Change your default shell

  `$ chsh -s /bin/zsh`

### custom git and vim

custom vim:

`$ curl -fsSL https://raw.githubusercontent.com/lexuszhi1990/ubuntu-handy-build/master/vim.conf -o ~/.vimrc`

for git basic conf:
`$ curl -fsSL https://raw.githubusercontent.com/lexuszhi1990/ubuntu-handy-build/master/git.conf -o ~/.gitconfig`

for git conf aliases:

`$ curl -fsSL https://raw.githubusercontent.com/lexuszhi1990/ubuntu-handy-build/master/git-alias.sh -o ~/.git-alias`

```
echo "
# load custom bash alias and configure for current user
if [ -f ~/.git-alias ]; then
    source ~/.git-alias
fi
" >> ~/.zshrc
```

