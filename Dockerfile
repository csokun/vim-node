FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV TERM xterm-256color

RUN apt-get update && apt-get install -y --no-install-recommends tmux ripgrep curl git jq inotify-tools fontconfig ca-certificates \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get update && apt-get install nodejs -y --no-install-recommends \
    && npm i -g eslint pino-pretty \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1000 nodejs && \
    useradd -s /bin/bash -r -u 1000 -g nodejs nodejs && \
    cp /bin/bash /bin/sh

ENV HOME=/home/nodejs

# neovim
COPY nvim/* $HOME/.config/nvim/
ADD https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz /tmp/
RUN cd /tmp && tar -xf nvim-linux64.tar.gz && \
    cp -a nvim-linux64/* /usr/local/ && \
    rm -rf /tmp/* && \
    # install Plug
    curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    nvim +PlugInstall +qall && \
    nvim -c 'CocInstall -sync coc-json coc-eslint coc-prettier coc-html coc-emmet coc-tsserver|q' && \
    # neovim alias
    ln -s /usr/local/bin/nvim /usr/local/bin/vim && \
    ln -s /usr/local/bin/nvim /usr/local/bin/vi

# git prompt
COPY bin/studio /usr/local/bin/studio
COPY .bashrc $HOME/.bashrc
RUN curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o $HOME/.git-prompt.sh && \
    chmod +x $HOME/.git-prompt.sh && \
    chmod +x /usr/local/bin/studio

# powerline fonts
RUN mkdir -p $HOME/.local/share/fonts && \
    curl -sL https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -o $HOME/.local/share/fonts/PowerlineSymbols.otf && \
    fc-cache -vf $HOME/.local/share/fonts/ && \
    mkdir -p $HOME/.config/fontconfig/conf.d/ && \
    curl -sL https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -o $HOME/.config/fontconfig/conf.d/10-powerline-symbols.conf

# tmux
COPY tmux/.tmux.conf $HOME/.tmux.conf

WORKDIR /src

# switch user
RUN chown -R nodejs $HOME /src \
    && echo "source ~/.bashrc" >> $HOME/.bash_profile
USER nodejs

CMD ["studio"]
