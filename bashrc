# vim: set filetype=sh:
# .bashrc

# ================================================================
# Systemwide setup
if [ -e /etc/bashrc ]; then
  . /etc/bashrc
fi

# ================================================================
# See README.md for more context.
#
# Files to source are from:
# o github.com/johnkerl/dotfiles
# o github.com/johnkerl/private-dotfiles (private repo)
# o Anything else work-related

boot=~/.bashrc-bootstrap
if [ ! -f $boot ]; then
  echo BASHRC: $boot not found
else
  . $boot

  #__set_verbose

  for init in \
    ~/.bashrcs-public/init \
    ~/.bashrcs-private/init \
    ~/.bashrc-work
  do
    if [ -e $init ]; then
      __maybe_say "BEGIN SOURCE $init"
      . $init
      __maybe_say "END   SOURCE $init"
    else
      __maybe_say "NOT FOUND $init"
    fi
  done
fi

# ================================================================
# The rest could go into my GitHub dotfiles repos, but, software-installation
# tools like to edit ~/.bashrc files directly. Sometimes it's easier to just let
# them do that.

# ----------------------------------------------------------------
# RUST
if [ -f "$HOME/.cargo/.env" ]; then
  . "$HOME/.cargo/env"
fi

# ----------------------------------------------------------------
# NVM
export NVM_DIR=~/.nvm
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ----------------------------------------------------------------
# PYENV
# if [ -f $HOME/.no-pyenv ]; then
#   echo "bashrc: Skipping pyenv init"
# fi
export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT/bin ] ; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
