# vim: set filetype=sh:
# .bashrc

# User-specific aliases and functions

# Source global definitions
if [ -e /etc/bashrc ]; then
	. /etc/bashrc
fi

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
# The rest is for interactive shells only.

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

# ----------------------------------------------------------------
# Rust
if [ -f "$HOME/.cargo/.env" ]; then
  . "$HOME/.cargo/env"
fi

# ----------------------------------------------------------------
# nvm

export NVM_DIR=~/.nvm
#export NVM_DIR=/usr/local/opt/nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
