## The Bash tool runs zsh: don't rely on bash word-splitting

On MacOS the Bash tool's shell is, by default, `/bin/zsh`. Unquoted parameter expansion does not
word-split in zsh the way it does in bash. Verified 2026-10-23:

- `spec="a b"; set -- $spec; echo $#` prints `1` in zsh, `2` in bash.

This has bitten us repeatedly: a loop like `for spec in "grafana/auth 1515" ...; do set -- $spec; gh
pr view $2 --repo $1` passes the whole string as `$1` and nothing as `$2`, so `gh` fails with
"argument required when using the --repo flag". Don't write that pattern.

Use one of these instead. All were verified in zsh:

- A function with explicit arguments, called once per item: `show() { gh pr view "$2" --repo "$1"
  ...; }; show grafana/auth 1515`
- `while read -r repo num; do ...; done <<EOF` with one item per line.
- Explicit `${=var}` to force splitting, only when the other options don't fit.
- Separate tool calls, run in parallel, when there are only a few items.

Related: when a command's output feeds a parser (`gh ... | python3 -c 'json.load(...)'`), a failure
in the first command shows up as an unrelated JSON traceback and hides the real error. Look at the
raw command output first, or capture it to a variable and check the exit status before parsing.
