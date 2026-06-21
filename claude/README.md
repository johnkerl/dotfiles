# What and why

These are things to go into my ~/.claude.

* [statusline-command.sh](statusline-command.sh) shows right there below the Claude Code prompt line which model I'm using, the token-in and token-out counts for the thread, context-window percent/token-count, and cumulative USD cost.
* [skills](skills) contains several keystroke-savers: nothingi too complex.

# Setup

```
ln -s $(pwd)/statusline-command.sh ~/.claude/statusline-command.sh
```

Due to Claude Code's lack of support for subdirectories of `~/.claude/skills`:

* If I want _all_ my skills to be tracked from here, I can do `ln -s $(pwd)/skills ~/.claude/skills`
If I have _any other_ skills in `~/.claude/skills`, then I need to symlink one at a time, one level deeper.
