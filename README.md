# johnkerl/dotfiles

A place to put my Linux/Unix dotfiles.  Growth by accretion and evolution, 1992-ish onwards.  See
also http://github.com/johnkerl/scripts.

## Manual setup

```
ln -s $(pwd)/bashrc         ~/.bashrc
ln -s $(pwd)/bashrcs-public ~/.bashrcs-public
ln -s $(pwd)/screenrc       ~/.screenrc
ln -s $(pwd)/vanilla        ~/.vanilla
ln -s $(pwd)/vimrc          ~/.vimrc
ln -s $(pwd)/R/environ      ~/.Renviron
ln -s $(pwd)/R/profile      ~/.Rprofile
```

You may need to add to `~/.bash_profile`:

```
. ~/.bashrc
```

## Scripted setup from checkout

* `bash ./install-dotfiles.sh` does setup of this repo's files.
* `bash ./install-full.sh` does setup of some of my other utility repos.

## Scripted setup from `curl`

`./download-and-install.sh` can be run in `curl`:

```
curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install.sh | bash
```

That clones this repo, then runs `bash ./install-dotfiles.sh`.

## See also

See also https://github.com/johnkerl/scripts/tree/master/suitcase and
https://github.com/johnkerl/away for other remote-setup options.

## Idea

* `~/.bashrc`, `~/.screenrc`, `~/.vimrc` are symlinked to point to `bashrc`, `screenrc`, `vimrc` here.
* `~/.bashrcs-public/` is symlinked to point to here.
* `~/.bashrc` sources `~/.bashrcs-public/init`
* `~/.bashrcs-public/init` is responsible for sourcing the other files in its directory.
* If `~/.bashrcs-private/` (symlink to file with `init`) and/or `~/.bashrc-work` (symlink to file)
  are present, they'll be sourced as well.
