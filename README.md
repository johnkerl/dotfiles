# johnkerl/dotfiles

This is a place to put my Linux/Darwin/Unix dotfiles. It's grown by accretion and evolution,
1992-ish onwards.  See also http://github.com/johnkerl/scripts.

## Setup option: scripted from checkout

Run either or both of these from within a checkout of this repo:

* `bash ./install-dotfiles.sh` does setup of this repo's files.
* `bash ./install-full.sh` does setup of some of my other utility repos.

## What this setup tries to accomplish

* Must work on MacOS and Linux, with minimal tweaking or duplication.
  * I don't attempt any other OS support, including NetBSD, etc.
* Must work on `zsh` and `bash` both, with minimal tweaking or duplication.
* Modularity:
  * Must function for my personal and work setups.
  * Must function for different employers.
  * Must not expose secrets.
  * Must not be a single `.bashrc` or `.zshrc` with hundreds of lines in it, with if-statements.
* Must be low-latency install:
  * Whenever I get a new laptop (which is infrequent).
  * Whenever I spin up a new EC2 instance (which is more frequent).
  * Any other ephemeral configurations (bashing into a Docker image for example).
* Must be stable over time.
  * Many of my dotfiles and scripts are (as of 2026) ten, twenty, or thirty years old. Something may break someday on a new system somewhere, and my memory won't be fresh.

What I do to accommodate these goals:

* MacOS and Linux: Very few changes are needed. Checking `uname` for `Darwin` suffices for me.
* `zsh`/`bash`: I use a single `.bzrc`.
* Modularity, including personal/work split, and working for different employers: top-level `.bzrc` looks at `.bzrcs-public/`, `.bzrcs-private`, and `.bzrcs-work`. 
  * `.bzrcs-public/` is for this repo.
  * `.bzrcs-private/` is for a private, personal-dotfiles repo.
  * `.bzrcs-work/` is for employer-specific things, such as project-specific aliases.
  * `.secrets` is for API keys, etc. that I never check into source control.
  * All but the last are directories with specific things in them. I can put prompt configs in one file, project-specific aliases in another, etc.
* Low-latency install: I have scripts like `download-and-install.sh`.
* Stability over time: I comment liberally so that one day when something changes unexpectedly, I can figure out what's going on and fix it.

## Setup option: scripted from `curl`

`./download-and-install.sh` can be run in `curl`:

```
curl https://raw.githubusercontent.com/johnkerl/dotfiles/refs/heads/main/install-dotfiles.sh | bash
```

That clones this repo to `~/git/johnkerl/dotfiles`, then `cd`'s there and runs `bash
./install-dotfiles.sh`.

## Setup option: manual

```
ln -s $(pwd)/bashrc         ~/.bashrc
ln -s $(pwd)/zshrc          ~/.zshrc
ln -s $(pwd)/bzrcs-public   ~/.bzrcs-public
ln -s $(pwd)/ctags          ~/.ctags
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

* At installation, `~/.bashrc`, `~/.zshrc`, `~/.screenrc`, `~/.vimrc` are symlinked to point to this repo's [`bashrc`](./bashrc), [`zshrc`](./zshrc), [`screenrc`](./screenrc), [`vimrc`](./vimrc) here.
* `~/.bzrcs-public/` is symlinked to point to [`bzrcs-public/`](./bzrcs-public/)here.
* `~/.bashrc` and `~/.zshrc` source [`~/.bzrcs-public/init`](./bzrcs-public/init). The `bz` reflects the fact that these scripts work with `bash` and `zsh` both.
* [`~/.bzrcs-public/init`](./bzrcs-public/init) is responsible for sourcing the other files in its directory.
* If `~/.bzrcs-private/` (a symlink to a directory containing an `init` file) and/or
  `~/.bzrc-work` (a symlink to a file) are present, they'll be sourced as well.
