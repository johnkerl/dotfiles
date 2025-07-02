#!/bin/bash

# ================================================================
# Usage:
# curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install.sh | bash
# curl -H 'Cache-Control: no-cache, no-store'  https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install.sh
# ================================================================


# ----------------------------------------------------------------
echo "HELLO"
set -euo pipefail

mkdir -p ~/git/johnkerl

cd ~/git/johnkerl
git clone https://github.com/johnkerl/dotfiles
cd dotfiles

# XXX TODO: separate the curl bits from the have-checked-out-repo bits
# XXX TODO: hostname-alias ...

# ----------------------------------------------------------------
# Check for existings

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
for item in \
  bashrc \
  bashrc_profile \
  bashrcs-public \
  bashrc-bootstrap \
  screenrc \
  vimrc
do
  ln -s $(pwd)/$item ~/.$item
  echo ln -s $(pwd)/$item ~/.$item
done
