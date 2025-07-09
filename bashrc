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
