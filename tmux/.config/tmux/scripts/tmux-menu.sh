#!/bin/bash

{
  tmux list-sessions -F '#S' | grep -v '^_popup_' | while read -r session; do
    echo "SESSION:$session"
    tmux list-windows -t "$session" -F 'WINDOW:#S:#I #W'
  done
} | sed -e 's/^SESSION:/🔻 /' -e 's/^WINDOW:/  ⭕/' | fzf --reverse |
  awk '{
    if ($1 == "🔻") {
      print $2
    }

    if ($1 == "⭕") {
      print $2
    }
}' | xargs tmux switch-client -t
