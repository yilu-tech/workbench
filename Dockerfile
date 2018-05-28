FROM ubuntu:18.04

LABEL maintainer="yilu-zzb <zhouzb@yilu-tech.com>"

# COPY sources.list /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y nginx php7.2 php7.2-fpm openssh-client git nodejs make python-dev g++ zsh

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/bin --filename=composer \
    && rm /composer-setup.php

# install oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
COPY yilu.zsh-theme /root/.oh-my-zsh/themes/yilu.zsh-theme
RUN sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="yilu"|' /root/.zshrc

# set chinese registry mirror for composer and npm
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com \
    && npm config set registry https://registry.npm.taobao.org | bash

RUN sed -i '/*.conf;/a\        include /workspace/*/nginx.conf;' /etc/nginx/nginx.conf

COPY startup /startup

RUN chmod +x /startup
RUN mkdir -p /workspace
WORKDIR /workspace

CMD ["/startup"]