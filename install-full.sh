#!/bin/bash

# ================================================================
# See README.md for context
# ================================================================

set -euo pipefail

export text_default=$'\033[0m'
export text_red=$'\033[31;01m'
export text_green=$'\033[32;01m'

# ----------------------------------------------------------------
clone_or_pull() {
  source="$1"
  destination="$2"

  if [ -d $destination ]; then
    echo
    echo "----------------------------------------------------------------"
    echo "johnkerl/dotfiles: updating $destination"
    echo
    pushd $destination
    git pull
    popd
    echo "${text_green}johnkerl/dotfiles: updating $destination${text_default}"
  else
    echo
    echo "${text_green}johnkerl/dotfiles: cloning $source to $destination${text_default}"
    echo
    git clone $source $destination
  fi

}

# ----------------------------------------------------------------
mkdir -p ~/git/johnkerl
clone_or_pull https://github.com/johnkerl/scripts            ~/scripts
clone_or_pull https://github.com/johnkerl/miller             ~/git/johnkerl/miller
clone_or_pull https://github.com/johnkerl/lumin              ~/git/johnkerl/lumin
clone_or_pull https://github.com/johnkerl/ec2-instance-tools ~/git/johnkerl/ec2-instance-tools

mkdir -p ~/bin
if [ ! -h ~/bin/ec2i ]; then
  ln -s ~/git/johnkerl/ec2-instance-tools/eci2 ~/bin/ec2i
fi

echo
echo "----------------------------------------------------------------"

# Go ahead and try these -- the OS might require yum or brew but I most often do
# repeat installs on Ubuntu EC2 instances so let's go with apt as the most
# hands-off install option.
export DEBIAN_FRONTEND=noninteractive # quiet update
sudo apt update -qq || echo "Could not sudo apt update"

# Some of my ~/scripts are in Ruby.
sudo apt install -y -qq ruby python-is-python3 || echo "Could not sudo apt install -y -q ruby python-is-python3"
# Some of my ~/scripts call /usr/bin/env python when they want python3.
sudo apt install -y -qq make golang-go || echo "Could not sudo apt install -y -q make golang-go"

echo
echo "${text_green}johnkerl/dotfiles: done trying Ruby, Python, Go${text_default}"
echo

echo
echo "----------------------------------------------------------------"

ok="true"
go version || ok="false"

if [ "$ok" = "true" ]; then
  cd ~/git/johnkerl/miller
  ./configure --prefix $HOME
  # make install
  make
  make -C man install
  if [ ! -h ~/bin/mlr ]; then
    ln -s $(pwd)/mlr ~/bin/mlr
  fi

  cd ~/git/johnkerl/lumin
  go build
  if [ ! -h ~/bin/lumin ]; then
    ln -s $(pwd)/lumin ~/bin/lumin
  fi

else
  echo "Could not find Go tools"
fi

echo "${text_green}johnkerl/dotfiles: done trying full install${text_default}"
