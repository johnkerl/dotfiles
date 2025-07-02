#!/bin/bash

# ================================================================
# Usage:
# curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install.sh | bash
#
# See also README.md for context.
# ================================================================

set -euo pipefail

# Clone the johnkerl/dotfiles repo.
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

# Install johnkerl/dotfiles repo.
bash ./install-dotfiles.sh

# If we're invoked with the -a flag, also install some other utility repos.
if [ "$#" -eq 1 ]; then
  if [ "$1" = "-a" ]; then
    bash ./install-full.sh
  fi
fi
