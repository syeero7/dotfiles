# .bashrc

# Source global definitions
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

if [ -f ~/.config/exercism/exercism_completion.bash ]; then
     source ~/.config/exercism/exercism_completion.bash
fi

if [ -f ~/zig-bash-completions.bash ]; then
     source ~/zig-bash-completions.bash
fi

export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

AGENT_ENV="${XDG_RUNTIME_DIR:-/tmp}/ssh-agent.env"

start_agent() {
    ssh-agent -s > "$AGENT_ENV"
    source "$AGENT_ENV" > /dev/null
}

if [ -f "$AGENT_ENV" ]; then
    source "$AGENT_ENV" > /dev/null
    ps -p "$SSH_AGENT_PID" > /dev/null 2>&1 || start_agent
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

append_to_path $HOME/.local/bin
append_to_path $HOME/bin
append_to_path $(go env GOPATH)/bin
append_to_path /usr/local/go/bin

append_to_path /usr/local/zig
append_to_path /usr/local/zig-dev # zig dev build

append_to_path /opt/nvim/bin

append_to_path $HOME/.local/language_servers/bin

function cmd_v() {
  echo -e '\033[01;7;33m COMMAND: '"$@"'\n\033[00m'; eval $@
}

alias gs='cmd_v git status'
alias ga='cmd_v git add'
alias gaa='cmd_v git add --all'
alias gc='cmd_v git commit'
alias gl='cmd_v git log --oneline'
alias gd='cmd_v git diff'
alias gp='cmd_v git push'

alias ..='cmd_v cd ..;pwd'
alias ...='cmd_v cd ../..;pwd'
alias ....='cmd_v cd ../../..;pwd'

alias trd='cmd_v tree --dirsfirst'
alias mkdir='mkdir -pv'
alias lah='cmd_v ls -lah'
alias tah='cmd_v tree -lah'
alias mkx='cmd_v chmod -v +x'

alias zts='cmd_v zig build test --summary all'

function git_branch() {
  output="$( git branch --show-current 2> /dev/null)"
  if [ $? -eq 0 ] ; then
    echo '   '"$output"
  fi
  unset output
}

function bash_prompt(){
    PS1='\[\033[01;36m\]\W\[\033[01;31m\]$(git_branch)\n\[\033[01;32m\]> \[\033[00m\]'

}

bash_prompt

eval "$(zoxide init bash)"
