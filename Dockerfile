FROM mcr.microsoft.com/devcontainers/universal

RUN apt update && apt install -y \
    fd-find \
    fzf \
    ripgrep

USER codespace

# Install starship
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# # Install various zsh plugins
RUN git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone --depth=1 https://github.com/esc/conda-zsh-completion ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/conda-zsh-completion

COPY --chown=codespace:codespace .zshrc .condarc /home/codespace/
COPY --chown=codespace:codespace starship.toml /home/codespace/.config/starship.toml

WORKDIR /home/codespace/

ENTRYPOINT [ "/bin/zsh" ]
