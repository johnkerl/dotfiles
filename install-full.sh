#!/bin/bash

# ================================================================
# XXX COMMENTS ON CONTEXT
# ================================================================

set -euo pipefail

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
  else
    echo
    echo "johnkerl/dotfiles: cloning $source to $destination"
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
sudo apt update -q || echo "Could not sudo apt update"

# Some of my ~/scripts are in Ruby.
sudo apt install -y -q ruby python-is-python3 || echo "Could not sudo apt install -y -q ruby python-is-python3"
# Some of my ~/scripts call /usr/bin/env python when they want python3.
sudo apt install -y -q make golang-go || echo "Could not sudo apt install -y -q make golang-go"

echo
echo "----------------------------------------------------------------"

ok="true"
go version || ok="false"

if [ "$ok" = "true" ]; then
  cd ~/git/johnkerl/miller
  ./configure --prefix $HOME
  make install

  cd ~/git/johnkerl/lumin
  go build
  cp lumin ~/bin/

else
  echo "Could not find Go tools"
fi
