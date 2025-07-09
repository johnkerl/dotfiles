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
# o ~/.bashrc-work:      Anything else work-related/site-related

# First, source things all the ~/.bzrcs-public/* files need.
__boot=~/.bashrc-bootstrap
if [ ! -f $__boot ]; then
  echo BASHRC: $__boot not found
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
      __maybe_say "BEGIN .BASHRC SOURCE $__init"
      . $__init
      __maybe_say "END   .BASHRC SOURCE $__init"
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
# BEGIN ANSIBLE MANAGED BLOCK
# Load homebrew shell variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_DIR=/opt/homebrew
export HOMEBREW_BIN=/opt/homebrew/bin

# Load python shims
eval "$(pyenv init -)"

# Load ruby shims
eval "$(rbenv init -)"

# Prefer GNU binaries to Macintosh binaries.
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# Add datadog devtools binaries to the PATH
export PATH="$HOME/dd/devtools/bin:$PATH"

# Point GOPATH to our go sources
export GOPATH="$HOME/go"

# Add binaries that are go install-ed to PATH
export PATH="$GOPATH/bin:$PATH"

# Point DATADOG_ROOT to ~/dd symlink
export DATADOG_ROOT="$HOME/dd"

# Tell the devenv vm to mount $GOPATH/src rather than just dd-go
export MOUNT_ALL_GO_SRC=1

# store key in the login keychain instead of aws-vault managing a hidden keychain
export AWS_VAULT_KEYCHAIN_NAME=login

# tweak session times so you don't have to re-enter passwords every 5min
export AWS_SESSION_TTL=24h
export AWS_ASSUME_ROLE_TTL=1h

# Helm switch from storing objects in kubernetes configmaps to
# secrets by default, but we still use the old default.
export HELM_DRIVER=configmap

# Go 1.16+ sets GO111MODULE to off by default with the intention to
# remove it in Go 1.18, which breaks projects using the dep tool.
# https://blog.golang.org/go116-module-changes
export GO111MODULE=auto
export GOPRIVATE=github.com/DataDog
# Configure Go to pull go.ddbuild.io packages.
export GOPROXY=binaries.ddbuild.io,https://proxy.golang.org,direct
export GONOSUMDB=github.com/DataDog,go.ddbuild.io
# END ANSIBLE MANAGED BLOCK
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

export GITLAB_TOKEN=$(security find-generic-password -a ${USER} -s gitlab_token -w)
