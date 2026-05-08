alias df='df -h'
alias du='du -h'
alias c='clear'
alias vim='nvim'
alias ls="eza -alh --icons --group-directories-first --git"
alias tmux='tmux -u'

alias claude='claude --append-system-prompt "$(cat ~/.config/claude/system-prompt.txt)"'
alias cc='claude --append-system-prompt "$(cat ~/.config/claude/system-prompt.txt)"'
alias cc-danger='claude --append-system-prompt "$(cat ~/.config/claude/system-prompt.txt)" --dangerously-skip-permissions'
alias cursor-cli='cursor-agent'
