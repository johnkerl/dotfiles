#!/bin/bash

# ================================================================
# Usage:
# curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install.sh | bash
# ================================================================

# ----------------------------------------------------------------
set -euo pipefail

dotfiles_url="https://github.com/johnkerl/dotfiles"
mkdir -p ~/git/johnkerl
cd ~/git/johnkerl
if [ -d dotfiles ]; then
  cd dotfiles
  echo ""
  echo "johnkerl/dotfiles: updating from $dotfiles_url"
  git pull
else
  echo ""
  echo "johnkerl/dotfiles: cloning $dotfiles_url"
  git clone https://github.com/johnkerl/dotfiles
  cd dotfiles
fi

bash ./install-dotfiles.sh

if [ "$#" -eq 1 ]; then
  if [ "$1" = "-a" ]; then
    bash ./install-full.sh
  fi
fi
