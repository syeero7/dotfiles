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

COMPLETIONS_DIR="$HOME/.bash-completions.d"

if [ -d "$COMPLETIONS_DIR" ]; then
  _dir_stat="$(stat -c '%a' "$COMPLETIONS_DIR")"
    if [  "$_dir_stat" -eq 700 ] || [ "$_dir_stat" -eq 755 ]; then

        while IFS= read -r -d '' file; do
            if [ ! -N "$file" ] && [ -r "$file" ]; then
                source "$file"
            fi
        done < <(find "$COMPLETIONS_DIR" -maxdepth 1 -type f -name "*.bash" -print0 2>/dev/null)
        
    fi
  unset _dir_stat
fi
unset COMPLETIONS_DIR

export EDITOR="$(which nvim)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

export PNPM_HOME="$HOME/.local/share/pnpm"
if [[ ":$PATH:" != *":$PNPM_HOME/bin:"* ]]; then
    export PATH="$PNPM_HOME/bin:$PATH"
fi

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

append_to_path "$HOME/.local/bin"
append_to_path "$HOME/bin"
append_to_path "$HOME/go/bin"
append_to_path "/usr/local/go/bin"

append_to_path "/usr/local/zig"
append_to_path "/usr/local/zig-dev" # zig dev build

append_to_path "/opt/nvim/bin"

append_to_path "$HOME/.local/language_servers/bin"

unset -f append_to_path

function _cmd_v() {
  echo -e '\033[01;7;33m COMMAND: '"$@"'\n\033[00m'; eval $@
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
  output="$( git branch --show-current 2> /dev/null)"
  if [ $? -eq 0 ] ; then
    echo '   '"$output"
  fi
  unset output
}

function _bash_prompt(){
    PS1='\[\033[01;36m\]\W\[\033[01;31m\]$(_get_git_branch)\n\[\033[01;32m\]> \[\033[00m\]'

}

_bash_prompt

eval "$(zoxide init bash)"

