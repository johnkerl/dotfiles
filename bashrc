# vim: set filetype=sh:
# .bashrc

# User-specific aliases and functions

# Source global definitions
if [ -e /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -e ~/.vars ]; then
	. ~/.vars
fi
if [ -e ~/.vars-personal ]; then
	. ~/.vars-personal
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
set mark-modified-lines off

# Without this, control-W at end of line on "ls /a/b/c/d" results in "ls".
# With this,    control-W at end of line on "ls /a/b/c/d" results in "ls /a/b/c".
stty werase undef
bind '"\C-w": backward-kill-word'
