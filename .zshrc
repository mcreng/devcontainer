bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
autoload -U compinit && compinit

export LANG=C.UTF-8
export FZF_DEFAULT_COMMAND='fd'

export ZSH="/home/$(whoami)/.oh-my-zsh"
plugins=(
    common-aliases
    git
    dotenv
    docker
    fzf
    gitignore
    history
    history-substring-search
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    conda-zsh-completion
)

source $ZSH/oh-my-zsh.sh


# For using docker in docker without sudo
[[ -f /logs/work ]] || sudo chown codespace:codespace /logs/work

eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
        . "/opt/conda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<