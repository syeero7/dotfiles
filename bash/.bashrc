# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

HISTCONTROL=ignoredups
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize

set -o vi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

if [ -f ~/.config/exercism/exercism_completion.bash ]; then
     source ~/.config/exercism/exercism_completion.bash
fi

if [ -f ~/zig-bash-completions.bash ]; then
     source ~/zig-bash-completions.bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

PATH=$PATH:$(go env GOPATH)/bin
PATH=$PATH:/usr/local/go/bin

PATH=$PATH:/usr/local/zig
PATH=$PATH:/usr/local/zig-dev # zig dev build

PATH=$PATH:/opt/nvim/bin

PATH=$PATH:$HOME/.local/language_servers/bin

export PATH

eval "$(starship init bash)"
eval "$(zoxide init bash)"

