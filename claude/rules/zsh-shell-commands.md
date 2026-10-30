## The Bash tool runs zsh: don't rely on bash word-splitting

On MacOS the Bash tool's shell is, by default, `/bin/zsh`. Unquoted parameter expansion does not
word-split in zsh the way it does in bash. Verified 2026-10-23:

- `spec="a b"; set -- $spec; echo $#` prints `1` in zsh, `2` in bash.

This has bitten us repeatedly: a loop like `for spec in "grafana/auth 1515" ...; do set -- $spec; gh
pr view $2 --repo $1` passes the whole string as `$1` and nothing as `$2`, so `gh` fails with
"argument required when using the --repo flag". Don't write that pattern.

The same applies to a command stored in a variable. Verified 2026-10-30: `c="echo a b"; $c` fails
with `command not found: echo a b` in zsh, because the whole string is treated as one command name.
Session transcripts have many `command not found: kubectl --context ... -n faro ...` errors of this
shape, and the matching commands do assign a kubectl string to a variable (`K="kubectl --context
... -n faro ..."`, seen 2026-10-30; the later line that invoked `$K` was not seen). Use an
array (`c=(echo a b); "${c[@]}"`) or a function, or `${=c}` as a last resort. Array and function
forms verified in zsh.

Use one of these instead. All were verified in zsh:

- A function with explicit arguments, called once per item: `show() { gh pr view "$2" --repo "$1"
  ...; }; show grafana/auth 1515`
- `while read -r repo num; do ...; done <<EOF` with one item per line.
- Explicit `${=var}` to force splitting, only when the other options don't fit.
- Separate tool calls, run in parallel, when there are only a few items.

Related: when a command's output feeds a parser (`gh ... | python3 -c 'json.load(...)'`), a failure
in the first command shows up as an unrelated JSON traceback and hides the real error. Look at the
raw command output first, or capture it to a variable and check the exit status before parsing.

## An unquoted glob that matches nothing is an error in zsh: quote patterns meant for the program

An unquoted word containing `*`, `?` or `[...]` that matches no files is a fatal error in zsh. Bash
passes it through literally. Verified 2026-10-30 (zsh 5.9, the Bash tool's shell):

- `echo --include=*.nonexistent_ext` prints `(eval):1: no matches found: --include=*.nonexistent_ext`
  in zsh, and `--include=*.nonexistent_ext` in bash.

This bit us with `grep -rniE foo dir --include=*.jsonnet`: the `--include=*.jsonnet` word is a glob
that matches nothing in the working directory, so zsh failed before `grep` ever ran. Same for `ls
some/dir/*.libsonnet` when that directory has no such files.

Use one of these instead:

- Quote patterns that the program should interpret: `--include='*.jsonnet'`, `-name '*.tf'`. Quoted
  `--include='*.tf'` and `--include='*.libsonnet'` worked in `grep -r` on 2026-10-30.
- Prefer the Grep and Glob tools over shell `grep`/`find` for searching.
- When the shell should expand the glob and zero matches is fine, run `setopt null_glob` (the glob
  vanishes) or `setopt nonomatch` (the glob is passed literally, as in bash). Both verified in a
  child `zsh -c`.
- Don't use the `*.ext(N)` null-glob qualifier. The Bash tool's zsh has `nobareglobqual` set, so
  `(N)` is not parsed and the command fails with `no matches found: *.ext(N)` (verified 2026-10-30).

Observed, not root-caused: in one call the failed glob sat in a pipeline and the later
`;`-separated commands still ran; in another it was the first command and nothing after it ran. So a
failed glob can silently drop one command while the rest of the line carries on. Read the output for
`no matches found` before trusting the rest of it.
