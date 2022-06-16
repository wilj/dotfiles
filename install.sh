#!/usr/bin/env bash
set -euxo pipefail

echo "$0 starting in $(pwd)"

cd .dotfiles

# append
cat files/.bashrc >> ~/.bashrc

# overwrite
cat files/.tmux.conf > ~/.tmux.conf

mkdir -p ~/.config/nvim/
cp files/.config/nvim/init.vim ~/.config/nvim/
if [ -n "$GITPOD_REPO_ROOT" ]; then
    cp files/.config/nvim/full.vim ~/.config/nvim/
    cp files/.config/nvim/coc-settings.json ~/.config/nvim/
fi

if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim +PlugInstall +qa

export NVM_DIR="$HOME/.nvm"
if [ ! -d $NVM_DIR ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install lts/fermium
fi
