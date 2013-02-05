# vim: set filetype=sh:
# .bashrc

# User-specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~kerl/.vars ]; then
	. ~kerl/.vars
fi
if [ -f ~kerl/.vars-personal ]; then
	. ~kerl/.vars-personal
fi

# ----------------------------------------------------------------
# The rest is for interactive shells only.

if [ "${-/i/}" = "$-" ] ; then
	return 0
fi

# ----------------------------------------------------------------

if [ -f ~kerl/.aliases ]; then
	. ~kerl/.aliases
fi

# I use a black background.  Replace (dark) blue with cyan for colored
# ls output.
# Later note:  this was OK on some OS version; not OK later.
# eval `dircolors|sed s/34/36/g`

# ----------------------------------------------------------------
# Turn that beeping off.
bind 'set bell-style none'
# Bash history-editing option.
set mark-modified-lines off

# Not functional in current bash:
#bind \\C-w:backward-kill-word
