#!/bin/bash

# ================================================================
# Usage:
# curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install.sh | bash
# ================================================================

# ----------------------------------------------------------------
set -euo pipefail

for item in \
  bashrc \
  bashrc_profile \
  bashrcs-public \
  bashrc-bootstrap \
  screenrc \
  vimrc \
  hostname-alias
do
  if [ -h ~/.$item ]; then
    echo "johnkerl/dotfiles: unlinking ~/.$item"
    rm ~/.$item
  else
    echo "johnkerl/dotfiles: link ~/.$item not found"
  fi
done
