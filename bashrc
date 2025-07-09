# vim: set filetype=sh:
# .bashrc

# ================================================================
# Systemwide setup
if [ -e /etc/bashrc ]; then
  . /etc/bashrc
fi

# ================================================================
# Use an installed checkout of https://github.com/johnkerl/dotfiles.
# See https://github.com/johnkerl/dotfiles/blob/main/README.md
#
# The files we source are from:
# o ~/.bzrcs-public/:  github.com/johnkerl/dotfiles (this is a public repo)
# o ~/.bzrcs-private/: github.com/johnkerl/private-dotfiles (this is private repo)
# o ~/.bzrc-work:      Anything else work-related/site-related

# First, source things all the ~/.bzrcs-public/* files need.
__boot=~/.bzrc-bootstrap
if [ ! -f $__boot ]; then
  echo BZRC: $__boot not found
else
  . $__boot

  # Uncomment this for some tracing. This causes __maybe_say to say things.
  #__set_verbose

  for __init in \
    ~/.bzrcs-public/init \
    ~/.bzrcs-private/init \
    ~/.bzrc-work
  do
    if [ -e $__init ]; then
      __maybe_say "BEGIN .BZRC SOURCE $__init"
      . $__init
      __maybe_say "END   .BZRC SOURCE $__init"
    else
      __maybe_say "NOT FOUND $__init"
    fi
  done
fi

# ================================================================
# The rest could go into my GitHub dotfiles repos, but, software-installation
# tools like to edit ~/.bashrc files directly. Sometimes it's easier to just let
# them do that. That way, if a tool install edits my ~/.bashrc, I'll see the
# double entries all in one place, right here.

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
# else
#   ...
# fi
export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT/bin ] ; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
