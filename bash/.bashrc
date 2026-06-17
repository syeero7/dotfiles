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

alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gl='git log --oneline'
alias gd='git diff'
alias gp='git push'

alias ..='cd ..;pwd'
alias ...='cd ../..;pwd'
alias ....='cd ../../..;pwd'

alias tree='tree --dirsfirst -F'
alias mkdir='mkdir -p -v'
alias lah='ls -lah'
alias tah='tree -lah'
alias mkx='chmod -v +x'

alias zts='zig build test --summary all'

function git_branch() {
    if [ -d .git ] ; then
        printf "%s""   $(git branch 2> /dev/null | awk '/\*/{print $2}')";
    fi
}

function bash_prompt(){
    PS1='\[\033[01;36m\]\W\[\033[01;31m\]$(git_branch)\n\[\033[01;32m\]> \[\033[00m\]'

}

bash_prompt

eval "$(zoxide init bash)"
