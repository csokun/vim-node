FROM csokun/vim-base:latest

USER root
RUN apk add --no-cache nodejs nodejs-npm

USER vim
COPY dotfiles/vimrc $HOME/.vimrc

# config global packages
RUN mkdir $HOME/.npm-global \
 && npm config set prefix '~/.npm-global' \
 && export PATH=$HOME/.npm-global/bin:$PATH \
 && npm i -g eslint pino-pretty

RUN echo | echo | vim +PluginInstall +qall

WORKDIR $HOME/work
