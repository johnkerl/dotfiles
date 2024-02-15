export BASH_SILENCE_DEPRECATION_WARNING=1
. ~/.bashrc

## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/Users/johnkerl/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/Users/johnkerl/miniconda/etc/profile.d/conda.sh" ]; then
#        . "/Users/johnkerl/miniconda/etc/profile.d/conda.sh"
#    else
#        export PATH="/Users/johnkerl/miniconda/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<

##
# Your previous /Users/johnkerl/.bash_profile file was backed up as /Users/johnkerl/.bash_profile.macports-saved_2022-09-19_at_17:49:26
##

# MacPorts Installer addition on 2022-09-19_at_17:49:26: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2022-09-19_at_17:49:26: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH="/opt/local/share/man:$MANPATH"
# Finished adapting your MANPATH environment variable for use with MacPorts.

# . "$HOME/.cargo/env"

## Setting PATH for Python 3.9
## The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.9/bin:${PATH}"
#export PATH

## Setting PATH for Python 3.12
## The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"
#export PATH
