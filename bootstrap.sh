#!/usr/bin/env bash

# clone
if ! [ -d ~/dotfiles/.git ]; then
  echo "Cloning repo..."
  cd ~
  git clone --recursive git@github.com:creasty/dotfiles.git
fi

cd ~/dotfiles

# install
source setups/install.sh

# create symbolic links
source setups/link.sh

# change login shell
source setups/shell.sh

# setup osx
source setups/osx.sh

