#!/bin/bash

# ================================================================
# Usage:
# curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install-dotfiles.sh | bash
# See also ./README.md for context.
# ================================================================

# ----------------------------------------------------------------
set -euo pipefail

for item in \
  bashrc \
  zshrc \
  bzrc_profile \
  bzrcs-public \
  bzrc-bootstrap \
  ctags \
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
