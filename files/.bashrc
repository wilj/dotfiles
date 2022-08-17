export NVM_DIR="$HOME/.nvm"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias vi=vim
alias tmux='tmux -u2 '
alias watch='watch '
alias k='kubectl '
complete -F __start_kubectl k
export DO='--dry-run=client -o yaml'

maybeComplete() {
    command -v $1 && . <($1 completion bash)
}

maybeComplete kubectl
maybeComplete k3d
maybeComplete k9s
maybeComplete helm

alias kaf='k apply -f '
alias kgp='k get pods '
alias ksn='k config set-context --current --namespace '

DEFAULTCOMMENT="wip skip ci"
g.commit() {
    local COMMENT
    if [ -d $1 ]; then
        COMMENT="$DEFAULTCOMMENT"
    else
        COMMENT="$*"
    fi

    local WHERE
    WHERE=$(git rev-parse --show-toplevel)
    if [ -z "$WHERE" ]; then
      WHERE=$GITPOD_REPO_ROOT
    fi

    if [ -z "$WHERE" ]; then
      echo "Not in a git repository"
    else
      echo "Committing $WHERE with comment '$COMMENT'"
      
      ( cd $WHERE \
          && git add . \
          && git commit -m"$COMMENT" \
          && git push )
    fi
}

g.commit-skip-ci() {
    local COMMENT
    if [ -d $1 ]; then
        COMMENT="$DEFAULTCOMMENT"
    else
        COMMENT="$* skip ci"
    fi
    gc $COMMENT
}

g.cd-gitpod-repo-root() {
    cd $GITPOD_REPO_ROOT/
}


cdgp() {
    g.cd-gitpod-repo-root
}

gc() {
    g.commit $*
}

gcs() {
    g.commit-skip-ci $*
}

dive() {
    docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        wagoodman/dive:latest $*
}


diff-docker-containers() {
    for c in $(docker ps -q | sort); do 
        echo $c; echo '---------------------'
        docker diff $c | sort -k2
        echo
    done
}
