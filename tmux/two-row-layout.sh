#!/usr/bin/env zsh
W=$(tmux display -p '#{window_width}')
H=$(tmux display -p '#{window_height}')
N=$(tmux list-panes | wc -l | tr -d ' ')

(( N < 2 )) && exit 0

TOP_N=$(( (N + 1) / 2 ))
BOT_N=$(( N - TOP_N ))
TOP_H=$(( (H - 1) / 2 ))
BOT_H=$(( H - 1 - TOP_H ))

IDS=( $(tmux list-panes -F '#{pane_top} #{pane_left} #{pane_id}' \
  | sort -k1,1n -k2,2n | awk '{gsub(/%/,"",$3); print $3}') )

row_spec() {
  local n=$1 rw=$2 rh=$3 x0=$4 y0=$5 off=$6
  local base=$(( (rw - n + 1) / n ))
  local extra=$(( (rw - n + 1) % n ))
  local x=$x0 inner=''
  for (( i=0; i<n; i++ )); do
    local pw=$(( i < extra ? base+1 : base ))
    [[ -n $inner ]] && inner+=','
    inner+="${pw}x${rh},${x},${y0},${IDS[$((off+i))]}"
    (( x += pw + 1 ))
  done
  (( n > 1 )) && echo "${rw}x${rh},${x0},${y0}{$inner}" || echo "$inner"
}

top=$(row_spec $TOP_N $W $TOP_H 0 0            0)
bot=$(row_spec $BOT_N $W $BOT_H 0 $((TOP_H+1)) $TOP_N)
body="${W}x${H},0,0[${top},${bot}]"

cs=0
for (( i=0; i<${#body}; i++ )); do
  ord=$(printf '%d' "'${body:$i:1}")
  cs=$(( ( ( (cs >> 1) | ((cs & 1) << 15) ) + ord ) & 0xffff ))
done

tmux select-layout "$(printf '%04x' $cs),${body}"
