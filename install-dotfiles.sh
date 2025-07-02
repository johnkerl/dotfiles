#!/bin/bash

# ================================================================
# See README.md for context
# ================================================================

set -euo pipefail

export text_default=$'\033[0m'
export text_red=$'\033[31;01m'
export text_green=$'\033[32;01m'

# ----------------------------------------------------------------
# Check for existings
echo ""
echo "johnkerl/dotfiles: checking for overwrites"

# ok="true"
# for file in \
#   ~/.bashrc \
#   ~/.bashrc_profile
# do
#   if [ -f "$file" ]; then
#     echo "File $file exists -- please rename it as backup"
#     ok="false"
#   fi
# done
# if [ "$ok" != "true" ]; then
#   exit 1
# fi

stamp=$(date "+%Y%m%d-%H%M%S")
for file in \
  ~/.bashrc \
  ~/.bashrc_profile
do
  if [ -f "$file" ]; then
    mv $file $file.$stamp
    echo "${text_green}johnkerl/dotfiles: mv $file $file.$stamp${text_default}"
  fi
done

# ----------------------------------------------------------------
echo ""
echo "johnkerl/dotfiles: installing symlinks"

for item in \
  bashrc \
  bashrcs-public \
  bashrc-bootstrap \
  screenrc \
  vimrc
do
  src=$(pwd)/$item
  dst=~/.$item
  if [ ! -e $src ]; then
    echo "johnkerl/dotfiles: cannot find $src to link to $dst"
  else
    if [ -h $dst ]; then
      echo "${text_green}johnkerl/dotfiles: link  $dst is okay${text_default}"
    else
      ln -s $src $dst
      echo ${text_green}"johnkerl/dotfiles: ln -s $src $dst${text_default}"
    fi
  fi
done

# ----------------------------------------------------------------
if [ "$#" -eq 1 ]; then
  echo "$1" > ~/.hostname-alias
  echo "${text_green}johnkerl/dotfiles: setting $1 in ~/.hostname-alias${text_default}"
fi

# ----------------------------------------------------------------
echo ""
echo "${text_green}johnkerl/dotfiles: done${text_default}"
echo ""
