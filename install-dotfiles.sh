#!/bin/bash

# ================================================================
# XXX COMMENTS ON CONTEXT
# ================================================================

# ----------------------------------------------------------------
# Check for existings
echo ""
echo "johnkerl/dotfiles: checking for overwrites"

ok="true"
for file in \
  ~/.bashrc \
  ~/.bashrc_profile
do
  if [ -f "$file" ]; then
    echo "File $file exists -- please rename it as backup"
    ok="false"
  fi
done
if [ "$ok" != "true" ]; then
  exit 1
fi

# ----------------------------------------------------------------
echo ""
echo "johnkerl/dotfiles: installing symlinks"

for item in \
  bashrc \
  bashrc_profile \
  bashrcs-public \
  bashrc-bootstrap \
  screenrc \
  vimrc
do
  if [ ! -f ./$item ]; then
    echo johnkerl/dotfiles: cannot find ./$item
  fi
  ln -s $(pwd)/$item ~/.$item
  echo johnkerl/dotfiles: ln -s $(pwd)/$item ~/.$item
done

# ----------------------------------------------------------------
if [ "$#" -eq 1 ]; then
  echo "$1" > ~/.hostname-alias
  echo "johnnkerl/dotfiles: setting $1 in ~/.hostname-alias"
fi

# ----------------------------------------------------------------
echo ""
echo "johnkerl/dotfiles: done"
echo ""
