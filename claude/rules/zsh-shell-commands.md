## Before you write any shell command in the Bash tool

This shell is zsh, and every failed attempt costs a rerun. Two defaults prevent most of them. Then
eight specific traps, each of which has already cost a rerun.

Default A: write every variable as `"${var}"`, braced and quoted, even when `$var` would do. It
removes the `$var:x` modifier trap (item 5) for free, and it is the habit that holds when you are
not thinking about it. Verified 2026-11-25 that `$H:libs` and `$H:apps` in a `git show` were eaten
as `:l` and `:a` while `"${H}:libs/..."` worked, with item 5 already in this file.

Default B: if the command needs a loop over strings, splitting a string into words, or any
bash-only syntax (item 8), run it as bash instead of translating it to zsh:

    bash <<'EOF'
    for p in "1877 epic" "2087 2087"; do set -- $p; echo "a=$1 b=$2"; done
    EOF

The quoted `'EOF'` keeps zsh from touching the body, so bash does all the expansion. Verified
2026-11-25 that this splits correctly and inherits the environment (`gh` auth, exported variables).
It is a fresh process, so it sees no zsh functions or variables; put everything it needs inside the
heredoc. `/bin/bash` here is 3.2.57 (no `${v^^}`, `mapfile` or associative arrays);
`/opt/homebrew/bin/bash` is 5.3.20 on this machine (verified `${v^^}` works there). Whether other
machines have a newer bash I have not checked.

Before sending, scan the command text for each of these, and fix it if present:

- a `$name` immediately followed by `:` (item 5), a `*`, `?` or `[` in a word that is not quoted
  (items 3 and 7), a word that starts with `=` (item 3), `set --` or an unquoted `$var` used as a
  list (item 1), a variable named `path` or `status` (item 6), and bash-only syntax (item 8).

If a result looks wrong in a way that smells like a mangled word (a missing letter, `no matches
found`, `command not found: <the whole string>`), suspect zsh first, `echo` the final string once,
fix it, and rerun once. Do not go exploring for another cause first.

A zsh error can abort the rest of the call. Verified 2026-11-25: after `no matches found` on an
`echo https://x.test/y?a=b`, the later `echo` in the same call never ran. So keep independent
checks in separate parallel calls, and never put a side effect after something that can fail this
way.

Eight things that work in bash silently break here. Check the command you are about to run against
this list:

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
5. Write `${var}`, never `$var`, when a `:` follows a variable inside a string, URL or path.
   zsh reads `$var:t`, `:h`, `:r`, `:e`, `:l`, `:u`, `:q`, `:a` as modifiers and silently eats the letter.
   The commonest trigger is git's `rev:path` form: always `git show "${sha}:path"`,
   `git cat-file -p "${sha}:path"`, `git diff "${a}:${f}" ...`, never `git show $sha:path`.
   This bit on 2026-11-18 (`.../projects/$P:testIamPermissions` became
   `...projects/grafanalabs-globalestIamPermissions`, a 404 that looked like a wrong endpoint) and
   on 2026-11-25 (`git show $H:libs/README.md` became `...ibs/README.md`, so git said "ambiguous
   argument"), the second time with this item already in the file. Read each URL, GCP resource
   name (`projects/$P:action`), `host:port` and git `rev:path` in the command before sending it.
6. Never name a shell variable `path`, `status`, `fpath`, `cdpath`, `manpath`, `module_path` or
   `mailpath`, not even as a `while read -r` or `for` loop variable. In zsh `path` is tied to
   `PATH`, so `read -r kind path num` or `path=$x` replaces the search path, and every later
   command (`gh`, `wc`, `head`) fails with `command not found`. `status` is read-only. This bit on
   2026-11-24: a loop `while read -r kind path num` made `gh` and `wc` vanish for the rest of
   that call. Use names like `seg`, `file`, `dir`, `rc`, `repo`, `num`, and read each loop's
   variable names before sending it.
7. Quote any URL, API path or argument that contains `?`, `[`, `]` or `*`:
   `gh api 'repos/ORG/REPO/pulls?state=open'`, `--jq '.[0]'`, `curl 'https://host/p?a=b&c=d'`.
   Unquoted, zsh treats them as globs and fails with `no matches found` before the program runs
   (and `&` backgrounds the command in any shell). Verified 2026-11-25 in the Bash tool:
   `echo https://x.test/y?a=b` fails with `no matches found`. In a clean `zsh -f` child,
   `echo a[0]` fails the same way.
8. Bash-only syntax fails in zsh. Run such a command as bash (Default B) instead of translating it.
   Verified 2026-11-25 in a clean `zsh -f` child:
   - `${v^^}` and `${v,,}`, `${!name}` and `${!arr[@]}` all fail with `bad substitution`.
   - `mapfile` fails with `command not found`, and `read -a arr` with `bad option: -a`.
   - Arrays start at 1: `a=(x y z); echo "${a[0]}"` prints an empty line.
   - `echo "a\tb"` prints a real tab in zsh (bash prints the backslash). Use `printf '%s\n'` for
     any text that may contain a backslash.

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

Not reproducing on 2026-11-25: in the Bash tool, `echo =ls` printed `=ls` and `echo ======` printed
`======`, and `setopt` there listed `noequals`. So the failures above may not happen in the current
tool shell. I don't know why it changed or whether it will stay that way, so keep quoting.

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

## `$var:x` is a history-style modifier in zsh: use `${var}` before a colon

In zsh, `$var:t` is not "the value of `var`, then `:t`". It is a modifier applied to the value. The
ones that matter are `:t` (tail, the last path component), `:h` (head, everything before the last
`/`), `:r` (strip the extension) and `:e` (the extension only). `:l` and `:u` change case, `:q`
quotes, and `:a` makes an absolute path from the current directory. Bash prints the colon and letter
unchanged. Verified 2026-11-18 (zsh 5.9, the Bash tool's shell):

- `P=grafanalabs-global; echo "$P:testIamPermissions"` prints `grafanalabs-globalestIamPermissions`.
  The `:t` was consumed as a modifier and the `t` vanished from the word.
- `echo "${P}:testIamPermissions"` prints `grafanalabs-global:testIamPermissions`.
- `F=/a/b/c.txt; echo "$F:t $F:h $F:r $F:e"` prints `c.txt /a/b /a/b/c txt`.
- `echo "$P:foo"` is unchanged, because `f` is not one of the modifiers. So the failure depends on
  the letter after the colon, which is why it looks random.
- `x=Hello; echo "$x:l $x:u $x:q $x:a"` prints `hello HELLO Hello /Users/kerl/git/grafana/app-o11y-kwl-endpoint/Hello`
  (the last one is the current directory plus the value).

This bit us calling the Google Resource Manager API
(`.../v1/projects/$P:testIamPermissions`; Google API "custom method" URLs end in a `:verb` suffix,
so every one of them is exposed to this). The mangled URL returned an HTML 404 saying `/v1/projects/grafanalabs-globalestIamPermissions`
was not found, and the first read was "wrong endpoint", not "my shell ate a letter". Quoting does not
help: the expansion happens inside double quotes too.

Do this instead:

- Always write `${var}` when anything follows the variable name that is not a space, `/` or end of
  word. It costs nothing and removes the whole class.
- Read the URL as echoed by the error, not as written in the command: the missing letter shows up
  in the error text.
- `$host:port` and `$host:3306` are fine (verified 2026-11-18: `:p` and digits are not modifiers
  here), but write `${host}:${port}` anyway so you never have to remember which letters bite.
- When in doubt, `echo` the final string once before sending it.

## `path` is tied to `PATH` in zsh: don't use it as a variable name

In zsh, some lowercase array names are tied to uppercase search-path variables, and `path` is the
one that matters. Assigning `path` assigns `PATH`. Verified 2026-11-24 (zsh 5.9, in a clean `zsh -f`
child shell):

- `path=foo; echo $PATH` prints `foo`, and the next external command fails with `command not
  found`.
- `while read -r kind path num; do :; done` does the same: `read` assigns `path`, and afterwards
  `wc` is `command not found`.
- `status=1` fails with `read-only variable: status`.
- `typeset -p fpath cdpath manpath module_path mailpath` shows each is tied to its uppercase twin
  (`typeset -aT`). I verified the tie, not what assigning each one breaks.
- A `local path=x` inside a function is restored when the function returns: after the call `PATH`
  had its old value. A top-level loop variable has no such protection.

This bit us in the Bash tool on 2026-11-24, in a loop that fetched issue and PR texts:
`while read -r kind path num; do dump "$kind" "$path" "$num"; done`. `gh` was `command not found`
inside `dump`, and so was `wc` afterwards. Every output file held the 28-byte error
`dump: command not found: gh`, and the first symptom was a directory of files that were all
28 bytes. Nothing in that error points at `PATH`; the cause only showed up after `wc` also failed.

Do this instead:

- Name loop and `read` variables for what they hold and avoid the tied names: `seg`, `file`,
  `dir`, `rc`, `repo`, `num`, `kind`. Use `rc`, not `status`, for an exit code.
- If a command suddenly reports `command not found` for something that worked a moment ago, run
  `echo "$PATH"` first. Look for a loop variable named `path` before suspecting the tool.
- Check the files a loop wrote (`ls -l`, sizes) before parsing them; a set of identical tiny sizes
  means the command failed the same way each time.

## `git show $sha:path` is the same trap as `$var:x`

This is the `$var:x` modifier problem (section above) in the form it most often takes: git's
`rev:path` syntax. Verified 2026-11-25 (zsh 5.9, the Bash tool's shell), reviewing a PR by SHA
without checking it out, with `H` holding a 40-character SHA:

- `git show $H:libs/README.md` failed with `ambiguous argument 'a2a8122...ibs/README.md'`. `:l` was
  consumed as the lowercase modifier, and the `l` of `libs` went with it.
- `git show $H:apps/errortracking/pkg/symbols/symbols.go` failed with `ambiguous argument
  '/Users/kerl/git/grafana/error-tracking/a2a8122...pps/errortracking/...'`. `:a` made the value an
  absolute path from the current directory and ate the `a` of `apps`.
- `git show "${H}:libs/README.md"` works. Quoting alone is not the fix; the braces are.
- The tell in the error text is a revision with one letter missing, or a repo path glued onto it.
- Same for `git cat-file -p`, `git ls-tree`, `git archive` and `git diff` whenever a `rev:path`
  argument is built from a variable.

## Unquoted `?`, `[` and `*` in URLs and API paths are globs in zsh

Verified 2026-11-25. In the Bash tool, `echo https://x.test/y?a=b` fails with `no matches found:
https://x.test/y?a=b`, and the call stopped there: the `echo` after it never ran. In a clean
`zsh -f` child, `echo a[0]` fails the same way. Bash passes both through literally.

Do this instead:

- Single-quote URLs and `gh api` paths that have a query string: `gh api
  'repos/ORG/REPO/pulls?state=open&per_page=100'`. Quote `--jq` programs too: `--jq '.[0].id'`.
- If the URL needs a variable, double-quote it and brace the variable:
  `"https://host/repos/${repo}/pulls?state=open"`.
- This is a close cousin of the unquoted-glob section above; the fix is the same, and the trigger
  is easy to miss because a URL does not look like a glob.

## Bash-only syntax: what fails in zsh, and the fix

Verified 2026-11-25 in a clean `zsh -f` child (zsh 5.9). The fix for all of these is Default B at the
top: run the command as bash. I have not verified the zsh-native equivalents, so I don't list them.

| Bash | In zsh |
| --- | --- |
| `${v^^}`, `${v,,}` | `bad substitution` |
| `${!name}`, `${!arr[@]}` | `bad substitution` |
| `mapfile -t x < file` | `command not found: mapfile` |
| `read -a arr` | `read: bad option: -a` |
| `${a[0]}` (first element) | empty; zsh arrays start at 1 |
| `echo "a\tb"` | prints a real tab; bash prints the backslash |

Also verified: an unquoted command substitution does split into words in zsh, so
`for x in $(echo "a b"); do ...; done` runs twice. The trap is only unquoted parameter expansion
(`$var`), not `$(cmd)`.

## Running a command as bash from the Bash tool

Verified 2026-11-25 (macOS, `/bin/bash` 3.2.57, `/opt/homebrew/bin/bash` 5.3.20):

- `bash <<'EOF' ... EOF` runs the body under bash with the caller's environment. A loop with
  `set -- $p` split `"1877 epic"` into `a=1877 b=epic` there, which fails in zsh.
- Use the quoted `'EOF'`. An unquoted `EOF` lets zsh expand `$` first and defeats the point.
- It is a fresh process: it does not see zsh functions or unexported variables. Anything it needs
  goes inside the heredoc, or is passed as an exported variable or an argument.
- `/bin/bash` 3.2 lacks `${v^^}`, `mapfile` and associative arrays. Call
  `/opt/homebrew/bin/bash` when you need them, and say so if another machine might not have it.
- The side-effect rule still applies: a command that closes, merges or applies goes in its own
  call, after you have read the loop's output.
