if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

HISTCONTROL=ignoredups
HISTSIZE=1000
HISTFILESIZE=1000

shopt -s histappend
shopt -s checkwinsize

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

export EDITOR="/usr/bin/nvim:$HOME/.local/bin/nvim"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export PNPM_HOME="$HOME/.local/share/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME/bin:"* ]]; then
  export PATH="$PNPM_HOME/bin:$PATH"
fi

AGENT_ENV="${XDG_RUNTIME_DIR:-/tmp}/ssh-agent.env"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --border=none \
  --color=bg+:#1a1b26 \
  --color=bg:#1e2030 \
  --color=border:#ad8ee6 \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#e0af68 \
  --color=hl+:#7aa2f7 \
  --color=hl:#7aa2f7 \
  --color=info:#444b6a \
  --color=marker:#f7768e \
  --color=pointer:#f7768e \
  --color=prompt:#7aa2f7 \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#ad8ee6 \
  --color=separator:#e0af68 \
  --color=spinner:#f7768e \
"

start_agent() {
  ssh-agent -s >"$AGENT_ENV"
  source "$AGENT_ENV" >/dev/null
}

if [ -f "$AGENT_ENV" ]; then
  source "$AGENT_ENV" >/dev/null
  ps -p "$SSH_AGENT_PID" >/dev/null 2>&1 || start_agent
else
  start_agent
fi

unset AGENT_ENV
unset -f start_agent

append_to_path() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$PATH:$1"
  fi
}

append_to_path "$HOME/.local/bin"
append_to_path "$HOME/bin"
append_to_path "$HOME/go/bin"

unset -f append_to_path

function _cmd_v() {
  echo -e '\033[01;7;33m COMMAND: '"$*"'\n\033[00m'
  "$@"
}

alias gs='_cmd_v git status'
alias ga='_cmd_v git add'
alias gaa='_cmd_v git add --all'
alias gc='_cmd_v git commit'
alias gl='_cmd_v git log --oneline'
alias gd='_cmd_v git diff'
alias gp='_cmd_v git push'

alias ..='_cmd_v cd ..;pwd'
alias ...='_cmd_v cd ../..;pwd'
alias ....='_cmd_v cd ../../..;pwd'

alias trd='_cmd_v tree --dirsfirst'
alias mkdir='mkdir -pv'
alias lah='_cmd_v ls -lah'
alias tah='_cmd_v tree -lah'
alias mkx='_cmd_v chmod -v +x'

alias aw='_cmd_v alacritty msg create-window --working-directory $PWD'
alias zts='_cmd_v zig build test --summary all'

function _get_git_branch() {
  output="$(git branch --show-current 2>/dev/null)"
  if [ $? -eq 0 ]; then
    echo '   '"$output"
  fi
  unset output
}

function _bash_prompt() {
  PS1='\[\033[01;36m\]\W\[\033[01;31m\]$(_get_git_branch)\n\[\033[01;32m\]> \[\033[00m\]'

}

_bash_prompt

eval "$(zoxide init bash)"
