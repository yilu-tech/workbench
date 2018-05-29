FROM ubuntu:18.04

LABEL maintainer="yilu-zzb <zhouzb@yilu-tech.com>"

RUN apt-get update

RUN apt-get install -y tzdata
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y nginx php7.2 php7.2-fpm openssh-client git make python-dev g++ zsh wget

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer \
    && rm /composer-setup.php

# install oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
COPY yilu.zsh-theme /root/.oh-my-zsh/themes/yilu.zsh-theme
RUN sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="yilu"|' /root/.zshrc

# install nodejs by nvm
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
ENV NVM_DIR /root/.nvm
RUN . $NVM_DIR/nvm.sh \
 && nvm install node \
 && echo 'export NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> /root/.zshrc

# set chinese registry mirror for composer and npm
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com \
    && npm config set registry https://registry.npm.taobao.org | bash

RUN sed -i '/sites-enabled/a\        include /workspace/*/nginx;' /etc/nginx/nginx.conf

COPY startup /startup

RUN chmod +x /startup
RUN mkdir -p /workspace
WORKDIR /workspace

CMD ["/startup"]