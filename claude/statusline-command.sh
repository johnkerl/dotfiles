#!/usr/bin/env bash

# Claude Code statusLine — context window + cost + effort + 5h rate limit (no pwd).
# Reads session JSON on stdin. 256-colors mirror ~/.bzrcs-public/prompt-rc.
#
# Example output:
#
# ❯ 
# ──────────────────────────────────────────────────────────────────────────────────────────────
#   [Sonnet 4.6 (1M context)]  32.8k in + 1.9k out / 1.0M 3%  ·  $0.15  ·  effort high

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  printf '%b' '\033[38;5;244m(install jq for the status line)\033[0m'
  exit 0
fi

# One jq pass → tab-separated fields, with safe defaults.
IFS=$'\t' read -r model cin cout csize cpct cost effort rl5 <<EOF
$(printf '%s' "$input" | jq -r '[
  (.model.display_name                    // "?"),
  (.context_window.total_input_tokens     // 0),
  (.context_window.total_output_tokens    // 0),
  (.context_window.context_window_size    // 0),
  (.context_window.used_percentage        // 0),
  (.cost.total_cost_usd                   // 0),
  (.effort.level                          // ""),
  (.rate_limits.five_hour.used_percentage // "")
] | @tsv')
EOF

# Humanize a token count: 1.2k / 15.5k / 142k / 1.0M
human() {
  awk -v n="${1:-0}" 'BEGIN{
    if      (n >= 1000000) printf "%.1fM", n/1000000;
    else if (n >= 100000)  printf "%.0fk", n/1000;
    else                   printf "%.1fk", n/1000;
  }'
}

# Colors (gold / amber / gray) + reset
g='\033[38;5;179m'; a='\033[38;5;136m'; d='\033[38;5;244m'; r='\033[0m'

cost=$(awk -v c="${cost:-0}" 'BEGIN{ printf "%.2f", c }')
ctx="${g}$(human "$cin")${d} in + ${g}$(human "$cout")${d} out ${d}/${g} $(human "$csize") ${g}${cpct%.*}%"

line="${g}[${model}]${r}  ${ctx}${r}  ${d}·  ${a}\$${cost}${r}"
[ -n "$effort" ] && line="${line}  ${d}·  effort ${g}${effort}${r}"
[ -n "$rl5" ]    && line="${line}  ${d}·  5h ${g}${rl5%.*}%${r}"

printf '%b' "$line"

