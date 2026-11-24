# What and why

These are things to go into my `~/.claude`.

* [statusline-command.sh](statusline-command.sh) shows right there below the Claude Code prompt line which model I'm using, the token-in and token-out counts for the thread, context-window percent/token-count, and cumulative USD cost.
* [skills](skills) contains several keystroke-savers: nothingi too complex.
* [CLAUDE.md](CLAUDE.md) holds my general working preferences: flagging uncertainty, full URLs, where drafts go, and so on.
* The [rules/zsh-shell-commands.md](rules/zsh-shell-commands.md) file addresses the issue that Claude is trained on using `bash`, but, MacOS systems (including mine) have `zsh` by default unless overridden (and I don't). I find experientially that Claude tries something, gets a syntax error or some other incorrect result, then tries again with something else that fixes syntax for `zsh`. Claude detects these and fixes them, so it works. The point of this rules file is to help Claude get the `zsh` syntax right the first time, for token-reduction.
* The [rules/posting-in-my-name.md](rules/posting-in-my-name.md) file says that nothing may appear on GitHub or Slack in my name unless I have seen it and approved it, and what counts as approval.
* The [rules/miller-box-tables.md](rules/miller-box-tables.md) file says how I convert tables copied from Claude Code with Miller.

# Setup

```
ln -s $(pwd)/statusline-command.sh ~/.claude/statusline-command.sh
ln -s $(pwd)/CLAUDE.md ~/.claude/CLAUDE.md
```

Each rules file is linked one at a time, since `~/.claude/rules` also holds rules that are not in this repository:

```
ln -s $(pwd)/rules/posting-in-my-name.md ~/.claude/rules/posting-in-my-name.md
```

Due to Claude Code's lack of support for subdirectories of `~/.claude/skills`:

* If I want _all_ my skills to be tracked from here, I can do `ln -s $(pwd)/skills ~/.claude/skills`
If I have _any other_ skills in `~/.claude/skills`, then I need to symlink one at a time, one level deeper.
