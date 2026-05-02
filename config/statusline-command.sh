#!/usr/bin/env bash
# Claude Code status line script
# Receives session JSON on stdin, outputs a single line to stdout

shopt -s extglob
export LC_ALL=C.UTF-8

input=$(cat)

# Extract every JSON field in a single jq invocation (vs 7 in the original).
{
  read -r cwd
  read -r ctx_size
  read -r used_tokens
  read -r used_pct
  read -r rl_pct
  read -r rl_resets
  read -r model
} < <(jq -r '
  .context_window.current_usage as $u
  | .cwd // .workspace.current_dir // ""
  , .context_window.context_window_size // ""
  , (if $u then ($u.input_tokens // 0) + ($u.cache_creation_input_tokens // 0) + ($u.cache_read_input_tokens // 0) else "" end)
  , .context_window.used_percentage // ""
  , .rate_limits.five_hour.used_percentage // ""
  , .rate_limits.five_hour.resets_at // ""
  , .model.display_name // .model.id // "unknown model"
' <<<"$input")

# Git branch — run from cwd so it reflects the right repo
git_branch=""
[ -n "$cwd" ] && git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

white=$'\e[97m'
reset=$'\e[0m'
purple=$'\e[38;5;135m'
green=$'\e[38;5;76m'
light_blue=$'\e[38;5;117m'

fmt_tokens() {
  local n=$1
  if (( n >= 1000000 )); then
    printf '%d.%dM' $((n / 1000000)) $(( (n % 1000000) / 100000 ))
  elif (( n >= 1000 )); then
    printf '%dk' $(( (n + 500) / 1000 ))
  else
    printf '%d' "$n"
  fi
}

make_bar() {
  local pct=$1 width=${2:-10} color=${3:-$green}
  local filled=$(( pct * width / 100 ))
  (( filled > width )) && filled=$width
  (( filled < 0 )) && filled=0
  local empty=$((width - filled)) f="" e=""
  (( filled > 0 )) && printf -v f "%${filled}s" ""
  (( empty  > 0 )) && printf -v e "%${empty}s"  ""
  printf '[%s%s%s%s]' "$color" "${f// /█}" "${e// /░}" "$white"
}

# Context field — prefer raw token counts; fall back to rounded percentage.
if [ -n "$used_tokens" ] && [ -n "$ctx_size" ] && (( ctx_size > 0 )); then
  pct=$(( used_tokens * 100 / ctx_size ))
  ctx_field="$(make_bar "$pct") $(fmt_tokens "$used_tokens") / $(fmt_tokens "$ctx_size")"
elif [ -n "$used_pct" ] && [ -n "$ctx_size" ]; then
  pct_int=${used_pct%.*}
  # used_pct may be fractional ("12.7"); preserve precision via awk for this rare fallback
  approx=$(awk -v p="$used_pct" -v s="$ctx_size" 'BEGIN {printf "%d", p * s / 100}')
  ctx_field="$(make_bar "$pct_int") $(fmt_tokens "$approx") / $(fmt_tokens "$ctx_size")"
elif [ -n "$used_pct" ]; then
  pct_int=${used_pct%.*}
  ctx_field="$(make_bar "$pct_int") ${pct_int}%"
else
  ctx_field="ctx: --"
fi

# CWD label with optional branch
cwd_label=""
if [ -n "$cwd" ]; then
  cwd_label=${cwd##*/}
  [ -n "$git_branch" ] && cwd_label="$cwd_label ${purple}($git_branch)${white}"
fi

# Build line 1
line1=""
for part in "$cwd_label" "$ctx_field" "$model"; do
  [ -z "$part" ] && continue
  [ -n "$line1" ] && line1+=" | "
  line1+=$part
done

# Line 2: 5h rate limit, bar widens to match line 1
line2=""
if [ -n "$rl_pct" ]; then
  rl_pct_int=${rl_pct%.*}
  rl_prefix="5h limit | "
  rl_suffix=" ${rl_pct_int}%"
  if [ -n "$rl_resets" ]; then
    printf -v now '%(%s)T' -1
    secs=$((rl_resets - now))
    if (( secs > 0 )); then
      h=$((secs / 3600))
      m=$(((secs % 3600) / 60))
      if (( h > 0 )); then
        rl_suffix+=" | resets in ${h}h ${m}m"
      else
        rl_suffix+=" | resets in ${m}m"
      fi
    fi
  fi
  # Visible width = char count of line1 with ANSI codes stripped
  stripped=${line1//$'\e'\[*([0-9;])m/}
  bar_w=$(( ${#stripped} - ${#rl_prefix} - 2 - ${#rl_suffix} ))
  (( bar_w < 1 )) && bar_w=10
  line2="${rl_prefix}$(make_bar "$rl_pct_int" "$bar_w" "$light_blue")${rl_suffix}"
fi

if [ -n "$line2" ]; then
  printf '%s%s\n%s%s%s\n' "$white" "$line1" "$white" "$line2" "$reset"
else
  printf '%s%s%s\n' "$white" "$line1" "$reset"
fi
