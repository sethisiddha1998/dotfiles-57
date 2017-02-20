#  General
#-----------------------------------------------
export LANG=ja_JP.UTF-8
export EDITOR=vim

export LSCOLORS='Gxfxcxdxbxegedabagacad'


#  Path
#-----------------------------------------------
# dotfiles
export DOTFILES_PATH="$HOME/dotfiles"

# golang
export GOPATH=$HOME/go

# tex
export TEXLIVE_PATH=/usr/local/texlive
export TEXLIVE_BIN_PATH=$TEXLIVE_PATH/2015/bin/universal-darwin
export TEXLIVE_TEXMR_PATH=$TEXLIVE_PATH/texmf-local

# android
export ANDROID_HOME=/usr/local/opt/android-sdk

# anyenv
export ANYENV_DIR=$HOME/.anyenv

# tmux
export TMUX_RESURRECT_SCRIPTS_PATH=~/.tmux/plugins/tmux-resurrect/scripts


#  Search path
#-----------------------------------------------
# local
export PATH=/usr/local/bin:$PATH

# anyenv
export PATH=$ANYENV_DIR/bin:$PATH

# dotfiles
export PATH=$DOTFILES_PATH/bin:$PATH

# golang
export PATH=$PATH:$GOPATH/bin

# heroku
export PATH=$PATH:/usr/local/heroku/bin

# haskell
export PATH=$PATH:$HOME/.cabal/bin

# tex
export PATH=$PATH:$TEXLIVE_BIN_PATH


#  Git
#-----------------------------------------------
export GIT_MERGE_AUTOEDIT='no'


#  Rails
#-----------------------------------------------
export DISABLE_SPRING=1
