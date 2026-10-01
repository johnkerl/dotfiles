#!/usr/bin/env bash

# Claude Code statusLine — context window + cost + effort + 5h rate limit (no pwd).
# Reads session JSON on stdin. 256-colors mirror ~/.bzrcs-public/prompt-rc.
#
# Example output:
#
# ❯ 
# ──────────────────────────────────────────────────────────────────────────────────────────────
#   [Sonnet 4.6 (1M context)]  32.8k in + 1.9k out / 1.0M 3%  ·  $0.15  ·  effort high

# ----------------------------------------------------------------
# Humanize a token count: 1.2k / 15.5k / 142k / 1.0M
humanize() {
  awk -v n="${1:-0}" 'BEGIN{
    if      (n >= 1000000) printf "%.1fM", n/1000000;
    else if (n >= 100000)  printf "%.0fk", n/1000;
    else                   printf "%.1fk", n/1000;
  }'
}

# ----------------------------------------------------------------
# Colors (gold / amber / gray) + reset
c1='\033[38;5;179m'
c2='\033[38;5;136m'
c3='\033[38;5;244m'
c0='\033[0m'

# ----------------------------------------------------------------
input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  printf '%b' '\033[38;5;244m(install jq for the status line)\033[0m'
  exit 0
fi

# One jq pass → tab-separated fields, with safe defaults.
IFS=$'\t' read -r model effort cin cout csize cpct cost rl5 <<EOF
$(printf '%s' "$input" | jq -r '[
  (.model.display_name                    // "?"),
  (.effort.level                          // ""),
  (.context_window.total_input_tokens     // 0),
  (.context_window.total_output_tokens    // 0),
  (.context_window.context_window_size    // 0),
  (.context_window.used_percentage        // 0),
  (.cost.total_cost_usd                   // 0),
  (.rate_limits.five_hour.used_percentage // "")
] | @tsv')
EOF

cost=$(awk -v c="${cost:-0}" 'BEGIN{ printf "%.2f", c }')
ctx="${c1}$(humanize "$cin")${c3} in + ${c1}$(humanize "$cout")${c3} out ${c3}/${c1} $(humanize "$csize") ${c1}${cpct%.*}%"

line="${c1}[${model}]${c0}"
[ -n "$effort" ] && line="${line} ${c3}· effort ${c1}${effort}${c0}"
line="${line} · ${ctx}${c0} ${c3}· ${c2}\$${cost}${c0}"
[ -n "$rl5" ]    && line="${line} ${c3}· 5h ${c1}${rl5%.*}%${c0}"

printf '%b' "$line"
