#!/bin/bash

# ================================================================
# Usage:
# curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install.sh | bash
# ================================================================

# ----------------------------------------------------------------
set -euo pipefail

dotfiles_url="https://github.com/johnkerl/dotfiles"
echo ""
echo "johnkerl/dotfiles: cloning $dotfiles_url"
mkdir -p ~/git/johnkerl
cd ~/git/johnkerl
git clone https://github.com/johnkerl/dotfiles
cd dotfiles

bash ./install-dotfiles.sh
