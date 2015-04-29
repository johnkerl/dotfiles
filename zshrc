# vim: set filetype=sh:
# .zshrc

if [ -f ~kerl/.vars ]; then
	. ~kerl/.vars
fi
if [ -f ~kerl/.vars-personal ]; then
	. ~kerl/.vars-personal
fi
if [ -f ~kerl/.vars-site ]; then
	. ~kerl/.vars-site
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
# Bash history-editing option.
set mark-modified-lines off

# Without this, control-W at end of line on "ls /a/b/c/d" results in "ls".
# With this,    control-W at end of line on "ls /a/b/c/d" results in "ls /a/b/c".
stty werase undef

set -o emacs
