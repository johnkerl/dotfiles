# vim: set filetype=sh:
# .zshrc

# ================================================================
# Systemwide setup
if [ -e /etc/zshrc ]; then
  . /etc/zshrc
fi

# ================================================================
# Use an installed checkout of https://github.com/johnkerl/dotfiles.
# See https://github.com/johnkerl/dotfiles/blob/main/README.md
#
# The files we source are from:
# o ~/.zshrcs-public/:  github.com/johnkerl/dotfiles (this is a public repo)
# o ~/.zshrcs-private/: github.com/johnkerl/private-dotfiles (this is private repo)
# o ~/.zshrc-work:      Anything else work-related/site-related

# First, source things all the ~/.zshrcs-public/* files need.
__boot=~/.bzrc-bootstrap
if [ ! -f $__boot ]; then
  echo ZSHRC: $__boot not found
else
  . $__boot

  # Uncomment this for some tracing. This causes __maybe_say to say things.
  # __set_verbose

  for __init in \
    ~/.bzrcs-public/init \
    ~/.bzrcs-private/init \
    ~/.bzrc-work
  do
    if [ -e $__init ]; then
      __maybe_say "BEGIN .ZSHRC SOURCE $__init"
      . $__init
      __maybe_say "END   .ZSHRC SOURCE $__init"
    else
      __maybe_say "NOT FOUND $__init"
    fi
  done
fi

# ================================================================
# The rest could go into my GitHub dotfiles repos, but, software-installation
# tools like to edit ~/.zshrc files directly. Sometimes it's easier to just let
# them do that. That way, if a tool install edits my ~/.zshrc, I'll see the
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
# This loads nvm zsh_completion
[ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"

# ----------------------------------------------------------------
# PYENV
# if [ -f $HOME/.no-pyenv ]; then
#   echo "zshrc: Skipping pyenv init"
# else
#   ...
# fi
export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT/bin ] ; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
