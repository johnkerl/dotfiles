#!/bin/bash

# ================================================================
# See README.md for context.
# ================================================================

set -euo pipefail

export __text_default=$'\033[0m'
export __text_red=$'\033[31;01m'
export __text_green=$'\033[32;01m'

# ----------------------------------------------------------------
# Check for existings
echo ""
echo "johnkerl/dotfiles: checking for overwrites"

stamp=$(date "+%Y%m%d-%H%M%S")
for file in \
  ~/.bashrc \
  ~/.bashrc_profile \
  ~/.zshrc
do
  if [ -f "$file" ]; then
    mv $file $file.$stamp
    echo "${__text_green}johnkerl/dotfiles: mv $file $file.$stamp${__text_default}"
  fi
done

# ----------------------------------------------------------------
echo ""
echo "johnkerl/dotfiles: installing symlinks"

for item in \
  bashrc \
  zshrc \
  bzrc-bootstrap \
  bzrcs-public \
  ctags \
  screenrc \
  vimrc
do
  if [ "$item" = "bashrc" ]; then
    # Link our bzrc to ~/.bashrc
    src=$(pwd)/bzrc
  elif [ "$item" = "zshrc" ]; then
    # Link our bzrc to ~/.zshrc
    src=$(pwd)/bzrc
  else
    # Link all other foo to ~/.foo
    src=$(pwd)/$item
  fi

  dst=~/.$item
  if [ ! -e $src ]; then
    echo "${__text_red}johnkerl/dotfiles: cannot find $src to link to $dst${__text_default}"
  else
    if [ -h $dst ]; then
      echo "${__text_green}johnkerl/dotfiles: link  $dst is okay${__text_default}"
    else
      ln -s $src $dst
      echo ${__text_green}"johnkerl/dotfiles: ln -s $src $dst${__text_default}"
    fi
  fi
done

# ----------------------------------------------------------------
if [ "$#" -eq 1 ]; then
  echo "$1" > ~/.hostname-alias
  echo "${__text_green}johnkerl/dotfiles: setting $1 in ~/.hostname-alias${__text_default}"
fi

# ----------------------------------------------------------------
echo ""
echo "${__text_green}johnkerl/dotfiles: done${__text_default}"
echo ""
