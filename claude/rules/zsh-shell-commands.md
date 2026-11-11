## Before you write any shell loop or variable-held command in the Bash tool

This shell is zsh. Four things that work in bash silently break here. Check the command you are
about to run against this list:

1. Never `set -- $var`, `for x in $var`, or `a=$var; cmd $a` to split a string. zsh does not
   split. Pass items to a function or `while read -r a b` loop instead (template below). This one
   has bitten repeatedly, most recently on 2026-11-11 with this item already in the file, and the
   second time it let a later command with a side effect run: see "A loop whose arguments came out
   empty" below. Before any loop that takes pairs, write it with the template, not with `set --`.
2. Never keep a command in a string variable (`K="kubectl --context ..."; $K ...`). Use an
   array, `K=(kubectl --context ...); "${K[@]}" ...`, or a function.
3. Quote any glob that the program, not the shell, should expand (`--include='*.tf'`), and
   quote any word that starts with `=`. That includes banner lines: never write `echo ======`
   or `echo =====`. Label sections with `echo '--- name'` or `echo "## name"` (a leading `-`, `#`
   or a quote is safe), or skip the banner. This one has bitten twice (2026-10-30 and 2026-11-10),
   the second time with this item already in the file, so read each `echo` in the command before
   sending it.
4. Never compare strings with `>` or `<` inside `[ ... ]` or `test`. They fail in zsh. Use
   `[[ "$a" > "$b" ]]`, or compare integers with `-gt`/`-lt`. And before any polling loop, run its
   condition once by itself and read the output: a condition that errors looks false, so the loop
   just runs to its timeout.

Default template for "do X for each (a, b) pair". Copy it, don't improvise:

    show() { gh pr view "$2" --repo "$1" --json state --jq .state; }
    while read -r repo num; do show "$repo" "$num"; done <<EOF
    grafana/auth 1515
    grafana/backend-enterprise 14720
    EOF

The details and evidence for each of these are below.

## The Bash tool runs zsh: don't rely on bash word-splitting

On MacOS the Bash tool's shell is, by default, `/bin/zsh`. Unquoted parameter expansion does not
word-split in zsh the way it does in bash. Verified 2026-10-23:

- `spec="a b"; set -- $spec; echo $#` prints `1` in zsh, `2` in bash.

This has bitten us repeatedly: a loop like `for spec in "grafana/auth 1515" ...; do set -- $spec; gh
pr view $2 --repo $1` passes the whole string as `$1` and nothing as `$2`, so `gh` fails with
"argument required when using the --repo flag". For `gh issue view` and `gh pr view` without
`--repo`, the same mistake shows up as "accepts 1 arg(s), received 0" (seen 2026-11-09). Don't
write that pattern.

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
- `items=("a 1" "b 2"); for spec in "${items[@]}"; do show ${=spec}; done` splits each element
  explicitly (verified 2026-11-09).
- Explicit `${=var}` to force splitting, only when the other options don't fit.
- Separate tool calls, run in parallel, when there are only a few items.

Related: when a command's output feeds a parser (`gh ... | python3 -c 'json.load(...)'`), a failure
in the first command shows up as an unrelated JSON traceback and hides the real error. Look at the
raw command output first, or capture it to a variable and check the exit status before parsing.

## A loop whose arguments came out empty still lets the rest of the line run

On 2026-11-11 a posting loop was written as
`for p in "1877 epic" "2087 2087" ...; do set -- $p; gh issue comment $1 --body-file post/$2.md; done;
gh issue close 1882 ...`. Because `set -- $p` does not split in zsh, `$1` was the whole string and
`$2` was empty, so every `gh` call failed with `open post/.md: no such file or directory`. The
loop did not stop, and the `gh issue close 1882` after it ran: the issue was closed without the
comment that was meant to go with it. Nine comments were not posted.

- Use the function template at the top, with explicit arguments: `post() { gh issue comment "$1"
  --body-file "post/$2.md"; }; post 1877 epic; post 2087 2087`. Verified in zsh.
- Put any command with a side effect that cannot be undone (closing an issue, merging, applying)
  in its own call, after reading the output of the loop that precedes it. Never chain it after a
  loop with `;`.
- Before running a loop for real, run it once with `echo` in place of the command and read the
  arguments it would pass.

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

## An unquoted word that starts with `=` is expanded as a command path in zsh

In zsh, an unquoted word starting with `=` is replaced by the full path of the command named after
it (`=ls` becomes `/bin/ls`), and the command line fails if there is no such command. Bash prints
the word unchanged. Verified 2026-10-30 in the Bash tool's shell:

- `echo ======` fails with `(eval):1: ===== not found`. In bash it prints `======`.
- `zsh -c 'echo =ls'` prints `/bin/ls`.

This bit us with a separator line, `echo ======`, in a diagnostic command. It happened again on
2026-11-10, in a command that read a PR description after a diff: the error was
`(eval):1: ===== not found` (one `=` fewer than typed), and the part
of the command after the `echo` did not run, so the description came back empty. Quote it:
`echo '======'` works (verified), and so does `echo "=== section"`, because the word does not
start with a bare `=`. Simplest is to avoid banners made of `=` and use `echo '--- name'`. A `=` in the middle or at the end of a word is fine: `a=b`, `x==` and `---===` printed
unchanged. `setopt noequals` also turns the expansion off (verified in a child `zsh -c`), but
quoting is simpler.

## `[ a > b ]` and `test a ">" b` don't work in zsh: use `[[ ]]`, and test a polling loop once first

zsh's `[` and `test` builtins don't support string ordering with `>` or `<`. Verified 2026-11-09 in
the Bash tool's shell:

- `t="22:06"; [ "$t" \> "22:00" ]` prints `zsh:1: condition expected: >` and exits 2. Same for
  `test "$t" ">" "22:00"`.
- `[[ "$t" > "22:00" ]]` works (true for `22:06`, false for `21:59`, false for an empty `$t`).
- Integer comparison works in `[ ]`: `[ 2206 -gt 2200 ]`.

This bit us in a wait loop, `until [ "$t" \> "22:00" ]; do sleep 20; done` style, inside a
background command: every iteration printed the error, the condition counted as false, and the
loop ran to its seven-minute timeout instead of stopping when the new Atlantis plan appeared. A
failing condition does not stop a `while` or `until` loop.

Do this instead:

- For HH:MM or ISO timestamps, `[[ "$t" > "22:00" ]]` (lexical order works for fixed-width strings),
  or convert to an integer first and use `-gt`.
- Before starting a polling loop, run its condition once on its own and read the output. If it
  prints an error, fix it before looping.
- For anything fiddly (dates, counts across API output), put the comparison in a short Python
  snippet that exits 0 or 1, and loop on that.
- Prefer a Monitor with an `until` loop over a long foreground `sleep`; the Bash tool blocks long
  foreground sleeps.
