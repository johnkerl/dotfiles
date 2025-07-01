# vim: set filetype=sh:
# .bashrc

# ================================================================
# Systemwide setup
if [ -e /etc/bashrc ]; then
  . /etc/bashrc
fi

# ================================================================
# Files to source are from:
# o github.com/johnkerl/dotfiles
# o github.com/johnkerl/private-dotfiles (private repo)
# o Anything else work-related

#way="old"
way="new"

if [ "$way" = "old" ]; then
  echo "BASHRC: OLD WAY"

  for file in \
    ~/.vars \
    ~/.vars-personal \
    ~/.vars-site-shared \
    ~/.vars-site \
    ~/.vars-tracker \
    ~/.aliases
  do
    if [ -e $file ]; then
      . $file
    fi
  done

  # I use a black background.  Replace (dark) blue with cyan for colored
  # ls output.
  # Later note:  this was OK on some OS version; not OK later.
  # eval `dircolors|sed s/34/36/g`

  # Turn the beeping off.
  bind 'set bell-style none'
  # Bash history-editing option.
  #set mark-modified-lines off

  # Without this, control-W at end of line on "ls /a/b/c/d" results in "ls".
  # With this,    control-W at end of line on "ls /a/b/c/d" results in "ls /a/b/c".
  stty werase undef
  bind '"\C-w": backward-kill-word'

  if [ $(uname) = "Linux" ]; then
      # Tab-complete `ls $foo/bar` -> `ls \$foo/bar` on Ubuntu 22.04 (EC2)
      # Non-broken on Mac these days
      shopt -s direxpand
  fi

else
  boot=~/.bashrc-bootstrap
  if [ ! -f $boot ]; then
    echo BASHRC: $boot not found
  else
    . $boot

    #__set_verbose

    for init in \
      ~/.bashrc-public/init \
      ~/.bashrc-private/init \
      ~/.bashrc-work/init
    do
      if [ -e $init ]; then
        __maybe_say "BEGIN SOURCE $init"
        . $init
        __maybe_say "END   SOURCE $init"
      fi
    done
  fi
fi

# ----------------------------------------------------------------
# This is how to skip the rest for non-interactive shells
# if [ "${-/i/}" = "$-" ] ; then
# 	return 0
# fi

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
