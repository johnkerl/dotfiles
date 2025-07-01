A place to put my Linux/Unix dotfiles.  Growth by accretion and evolution, 1992-ish onwards.
See also http://github.com/johnkerl/scripts.

Idea for localhost setup:

```
ln -s $(pwd)/bashrc         ~/.bashrc
ln -s $(pwd)/bashrcs-public ~/.bashrcs-public
ln -s $(pwd)/screenrc       ~/.screenrc
ln -s $(pwd)/vanilla        ~/.vanilla
ln -s $(pwd)/vimrc          ~/.vimrc
ln -s $(pwd)/R/environ      ~/.Renviron
ln -s $(pwd)/R/profile      ~/.Rprofile
```

Then:

In `~/.bash_profile` add

```
. ~/.bashrc
```

See also https://github.com/johnkerl/scripts/tree/master/suitcase for a remote-setup option.
