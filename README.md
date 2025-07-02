# johnkerl/dotfiles

This is a place to put my Linux/Darwin/Unix dotfiles. It's grown by accretion and evolution,
1992-ish onwards.  See also http://github.com/johnkerl/scripts.

## Setup option: scripted from checkout

Run either or both of these from within a checkout of this repo:

* `bash ./install-dotfiles.sh` does setup of this repo's files.
* `bash ./install-full.sh` does setup of some of my other utility repos.

## Setup option: scripted from `curl`

`./download-and-install.sh` can be run in `curl`:

```
curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install.sh | bash
```

That clones this repo to `~/git/johnkerl/dotfiles`, then `cd`'s there and runs `bash
./install-dotfiles.sh`.

## Setup option: manual

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

## See also

See also https://github.com/johnkerl/scripts/tree/master/suitcase and
https://github.com/johnkerl/away for other remote-setup options.

## Structure

* At installation, `~/.bashrc`, `~/.screenrc`, `~/.vimrc` are symlinked to point to this repo's [`bashrc`](./bashrc), [`screenrc`](./screenrc), [`vimrc`](./vimrc) here.
* `~/.bashrcs-public/` is symlinked to point to [`bashrcs-public/`](./bashrcs-public/)here.
* `~/.bashrc` sources [`~/.bashrcs-public/init`](./bashrcs-public/init).
* [`~/.bashrcs-public/init`](./bashrcs-public/init) is responsible for sourcing the other files in its directory.
* If `~/.bashrcs-private/` (a symlink to a directory containing an `init` file) and/or
  `~/.bashrc-work` (a symlink to a file) are present, they'll be sourced as well.
