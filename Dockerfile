FROM csokun/vim-base:dev

USER root
# install nvm - Node Version Manager
RUN NODE_NVM_VERSION=$(curl -sL "https://api.github.com/repos/creationix/nvm/tags" | jq ".[0].name" | sed 's/\"//g') \
  && wget -qO- https://raw.githubusercontent.com/creationix/nvm/${NODE_NVM_VERSION}/install.sh | bash \
  && /bin/bash -c "source ~/.bashrc; nvm install --lts; npm i -g eslint pino-pretty" \
  && chown -R vim:vimuser /home/vim/.config

USER vim
COPY dotfiles/vimrc $HOME/.vimrc

RUN ln -s /work $HOME/work
RUN echo | echo | vim +PluginInstall +qall

WORKDIR $HOME/work
