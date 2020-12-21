FROM alpine:edge

USER root

ENV LANG=C.UTF-8

RUN apk add --update --no-cache \
    # https://github.com/sharkdp/bat
    bat \ 
    # https://github.com/Canop/broot
    broot \
    curl \
    docker \
    # https://github.com/sharkdp/fd
    fd \
    # https://github.com/junegunn/fzf
    fzf \
    git \
    htop \
    man-db \
    man-pages \
    ncdu \
    perl \
    # https://github.com/BurntSushi/ripgrep \
    ripgrep \
    # adduser and usermod
    shadow \
    sudo \
    vim \
    zsh && \
    adduser --disabled-password developer && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/wheel && \
    usermod -a -G wheel,docker developer

# Install GCC
RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.32-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
    "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    apk del glibc-i18n && \
    rm "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda3.sh && \
    /bin/zsh Miniconda3.sh -b -p /opt/conda && \
    rm Miniconda3.sh

# Install texlive
WORKDIR /tmp/install-texlive
COPY texlive.profile /tmp/install-texlive/
RUN wget ftp://tug.org/historic/systems/texlive/2021/install-tl-unx.tar.gz && \
    tar --strip-components=1 -xvf install-tl-unx.tar.gz && \
	./install-tl --profile texlive.profile && \
	cd && rm -rf /tmp/install-texlive
WORKDIR /home/developer

USER developer

# Install various zsh plugins
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    zsh ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/gitstatus/install && \
    git clone --depth=1 https://github.com/esc/conda-zsh-completion ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/conda-zsh-completion

COPY .zshrc .p10k.zsh /home/developer/

RUN /opt/conda/bin/conda init zsh

WORKDIR /home/developer/

ENTRYPOINT [ "/bin/zsh" ]
