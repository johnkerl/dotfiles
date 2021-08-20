A place to put my Linux/Unix dotfiles.  Growth by accretion and evolution, 1992-ish onwards.
See also http://github.com/johnkerl/scripts

Idea for localhost setup:
```
ln -s $(pwd)/aliases      ~/.aliases
ln -s $(pwd)/bashrc       ~/.bashrc
ln -s $(pwd)/colorrc      ~/.colorrc
ln -s $(pwd)/mypy         ~/.mypy
ln -s $(pwd)/vanilla      ~/.vanilla
ln -s $(pwd)/vars         ~/.vars
ln -s $(pwd)/vars-tracker ~/.vars-tracker
ln -s $(pwd)/vimrc        ~/.vimrc
```

Then:

In `~/.bash_profile` add

```
. ~/.bashrc
```

See also https://github.com/johnkerl/scripts/tree/master/suitcase for a remote-setup option.

Conventions:

* `~/.vars` is `PS1` and `PATH`
* `~/.aliases` (misnamed) is everything else -- mostly, but not entirely, aliases and shell functions
* `~/.vars-personal` not in source control
* `~/.vars-site` not in source control -- job-specific things go here

foo test
