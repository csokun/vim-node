FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install tmux curl git jq ca-certificates -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# install nvm - Node Version Manager
RUN NODE_NVM_VERSION=$(curl -sL "https://api.github.com/repos/creationix/nvm/tags" | jq ".[0].name" | sed 's/\"//g') \
  && curl -sL https://raw.githubusercontent.com/creationix/nvm/${NODE_NVM_VERSION}/install.sh | bash - \
  && bash -c "source /root/.bashrc; nvm install --lts; npm i -g eslint pino-pretty"


# tmux
COPY tmux/.tmux.conf /root/.tmux.conf

# neovim
COPY nvim/* /root/.config/nvim/
ADD https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz /tmp/
RUN cd /tmp && tar -xf nvim-linux64.tar.gz && \
    cp -a nvim-linux64/* /usr/local/ && \
    rm -rf /tmp/* && \
    # install Plug
    curl -fLo /root/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    nvim +PlugInstall +qall && \
    nvim -c 'CocInstall -sync coc-json coc-html coc-emmet coc-tsserver|q' && \
    # neovim alias
    ln -s /usr/local/bin/nvim /usr/local/bin/vim && \
    ln -s /usr/local/bin/nvim /usr/local/bin/vi

# git prompt
COPY bin/studio /usr/local/bin/studio
COPY .bashrc /root/.bashrc
RUN curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o /root/.git-prompt.sh && \
    chmod +x /root/.git-prompt.sh && \
    chmod +x /usr/local/bin/studio

WORKDIR /src

CMD ["studio"]
