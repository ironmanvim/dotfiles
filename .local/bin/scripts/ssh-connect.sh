#!/bin/bash

ssh_file_path="$HOME/.ssh/config"
ssh_host_names=$(grep "Host " <"$ssh_file_path")

while IFS= read -r line; do
  IFS=' ' read -ra array <<<"$line"
  ssh_names+="${array[1]} "
done <<<"$ssh_host_names"

# ssh_names="oracle_harsha oracle_ironmanvim oracle_ravirapolu oracle_badanapuramsaroja oracle_bav oracle_bav_2 oracle_vardhan57727"
selected=$(echo "$ssh_names" | tr ' ' '\n' | fzf)

selected_name="ssh-$selected"
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" "ssh $selected"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" "ssh $selected"
fi

tmux switch-client -t "$selected_name"
