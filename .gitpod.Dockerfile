FROM gitpod/workspace-full

USER root

RUN export DEBIAN_FRONTEND='noninteractive' \
    && apt-get update \
    && apt-get install -y \
        netcat \
        build-essential \
        gettext \
        sshfs \
        tldr \
    && wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.deb \
    && sudo dpkg -i nvim-linux64.deb \
    && rm nvim-linux64.deb \
    && rm -rf /var/lib/apt/lists/*

USER gitpod