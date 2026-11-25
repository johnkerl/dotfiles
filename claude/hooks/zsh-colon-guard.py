#!/usr/bin/env python3
"""PreToolUse hook for the Bash tool: reject `$name:<modifier letter>`.

The Bash tool's shell is zsh. In zsh, `$H:libs` is not "the value of H, then ':libs'":
`:l` is a modifier (lowercase) and it eats the letter, so `git show $H:libs/x` becomes
`git show <value>ibs/x`. Writing `${H}:libs` avoids it.

The letters below were found by trying every letter after `$x:` in a clean `zsh -f`
(zsh 5.9, 2026-11-25): each one changed the output. `p`, `f`, `g`, `x`, `w` and digits did not,
so `$host:port` and `$host:5432` are allowed.

Text that zsh does not expand is ignored: single-quoted strings, quoted heredoc bodies
(`<<'EOF'`) and backslash-escaped dollars. Everything else is scanned, including double
quotes and unquoted heredocs, because zsh expands inside them.

Exit 2 with a message on stderr blocks the command and shows the message to Claude.
Any internal error exits 0: a bug here must never block work.
"""
import json
import re
import sys

MODIFIERS = "acehlqrstuAPQ"

# <<'EOF' ... EOF and <<"EOF" ... EOF: the body is never expanded by zsh.
QUOTED_HEREDOC = re.compile(
    r"(<<-?[ \t]*(['\"])(\w+)\2)([^\n]*)\n.*?\n[ \t]*\3[ \t]*(?:\n|$)", re.S
)
SINGLE_QUOTED = re.compile(r"'[^']*'")
ESCAPED_DOLLAR = re.compile(r"\\\$")
TRAP = re.compile(r"\$([A-Za-z_][A-Za-z0-9_]*|[0-9]+):([" + MODIFIERS + r"])")


def scan(command):
    text = QUOTED_HEREDOC.sub(lambda m: m.group(4) + "\n", command)
    text = SINGLE_QUOTED.sub("''", text)
    text = ESCAPED_DOLLAR.sub("", text)
    seen = []
    for m in TRAP.finditer(text):
        hit = (m.group(1), m.group(2))
        if hit not in seen:
            seen.append(hit)
    return seen


def main():
    try:
        command = json.load(sys.stdin).get("tool_input", {}).get("command", "")
        hits = scan(command) if isinstance(command, str) else []
    except Exception:
        return 0
    if not hits:
        return 0
    lines = ["zsh would eat a letter here, so this command was not run. Brace the variable:"]
    for name, letter in hits:
        lines.append(f"  ${name}:{letter}...  ->  ${{{name}}}:{letter}...")
    lines.append(
        "In zsh, $var:X with X in [" + MODIFIERS + "] is a history-style modifier (for example"
        " :l lowercases and :a makes an absolute path). If you meant the modifier,"
        " write ${var:X}. Then resend the command."
    )
    print("\n".join(lines), file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main())
