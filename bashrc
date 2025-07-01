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

# Bootstrap:
# * Verbosity
# * Function to get sourcefile name
# * vars-tracker

# 0 /Users/kerl/.bashrc
# 1 /Users/kerl/.bashrc-public/third-level
# 2 /Users/kerl/.bashrc-public/second-level
# 3 /Users/kerl/.bashrc-public/init
# 4 /Users/kerl/.bashrc
# 5 /Users/kerl/.bash_profile

# foo() {
#   echo 0 ${BASH_SOURCE[0]}
#   echo 1 ${BASH_SOURCE[1]}
#   echo a ${BASH_SOURCE[@]}
#   echo n ${#BASH_SOURCE[@]}
#   echo ? ${BASH_SOURCE}
#   echo p $(pwd)
# }

__get_source_name() {
  echo 1 ${BASH_SOURCE[1]}
}

__set_verbose() {
  export __VERBOSE=true
}

__unset_verbose() {
  unset __VERBOSE
}

boot=~/.bashrc-bootstrap
if [ ! -f $boot ]; then
  echo BASHRC: $boot not found
else
  . $boot

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

# ----------------------------------------------------------------
# In this repo
if [ -e ~/.vars ]; then
	. ~/.vars
fi

# Not in this repo -- perhaps in a private repo
if [ -e ~/.vars-personal ]; then
	. ~/.vars-personal
fi
if [ -e ~/.vars-site-shared ]; then
	. ~/.vars-site-shared
fi
if [ -e ~/.vars-site ]; then
	. ~/.vars-site
fi

# ----------------------------------------------------------------
# This is how to skip the rest for non-interactive shells
if [ "${-/i/}" = "$-" ] ; then
	return 0
fi

# ----------------------------------------------------------------

if [ -f ~/.vars-tracker ]; then
	. ~/.vars-tracker
fi
if [ -f ~/.aliases ]; then
	. ~/.aliases
fi

# I use a black background.  Replace (dark) blue with cyan for colored
# ls output.
# Later note:  this was OK on some OS version; not OK later.
# eval `dircolors|sed s/34/36/g`

# ----------------------------------------------------------------
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
