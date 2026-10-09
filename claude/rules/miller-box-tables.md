## Miller (mlr) can convert tables copied from Claude Code

John wrote Miller. Since 6.22.0 it has a Unicode box-drawing tabular format (flags `--box`, `--ibox`,
`--obox`; release note "Support Unicode-boxed I/O format: tabular with UTF-8 markers", PR 2253,
https://github.com/johnkerl/miller/releases/tag/v6.22.0). He added it so that tables shown in Claude Code
(the box-drawing tables in terminal output) can be copied and converted for pasting elsewhere.

When John asks for a table he will paste into another tool, give him the table in the reply and, if useful,
the one-liner. On macOS, with the table on the clipboard:

- TSV, for Google Sheets: `pbpaste | mlr --ibox --otsv cat`
- JSON: `pbpaste | mlr --ibox --ojson cat`
- GitHub Markdown: `pbpaste | mlr --ibox --omd cat`
- CSV: `pbpaste | mlr --ibox --ocsv cat`

Verified 2026-10-09 on his machine (`~/bin/mlr`, version 6.22.0-dev): a box table round-trips to TSV, JSON and
Markdown. Not verified: how very wide or wrapped cells survive a copy from the terminal, and whether other
machines have a Miller new enough for `--ibox`; check `mlr --version` before assuming.

Google Docs tables: "Paste from Markdown" did not work for John. Rendered HTML pasted from a browser keeps the
table, so for a Docs table write an HTML file to `~/Desktop` (see `~/Desktop/decisions-box.html` for an
example) or give TSV for a Sheets detour.
