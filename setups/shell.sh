#!/usr/bin/env bash

#  Change login shell
#-----------------------------------------------
if ! [ $ZSH_NAME ]; then
  sudo -s
  mv /etc/zshenv /etc/_zshenv
  echo "\n/usr/local/bin/zsh" >> /etc/shells
  exit
  chpass -s /usr/local/bin/zsh
fi


