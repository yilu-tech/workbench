FROM nginx:alpine

LABEL maintainer="yilu-zzb <zhouzb@yilu-tech.com>"

RUN sed -i "s|dl-cdn.alpinelinux.org|mirrors.aliyun.com|g" /etc/apk/repositories \
 && sed -i "s|http|https|g" /etc/apk/repositories \ 
 && apk update \

 && apk add php7 \
            php7-fpm \
            php7-openssl \
            php7-pdo_mysql \
            php7-mbstring \
            php7-tokenizer \
            php7-xml \
            php7-xmlwriter \
            php7-simplexml \
            php7-dom \
            php7-session \
            php7-ctype \
            php7-bcmath \
            php7-json \
            php7-phar \
            php7-curl \
            php7-iconv \
            php7-mcrypt \
            php7-gd \
            php7-gmp \
            php7-fileinfo\
            php7-opcache \
            php7-xdebug \
            php7-zip \
            libbsd \

 && apk add openssh-client git make python-dev g++ zsh \

# install composer
 && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/bin --filename=composer \
 && rm /composer-setup.php

# install oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
 && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
COPY yilu.zsh-theme /root/.oh-my-zsh/themes/yilu.zsh-theme
RUN sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="yilu"|' /root/.zshrc

# set chinese registry mirror for composer and npm
RUN composer config -g repo.packagist composer https://packagist.laravel-china.org
 && sed -i '/*.conf;/a\    include /workspace/*/nginx.conf;' /etc/nginx/nginx.conf

COPY cmd/php-restart /usr/local/bin/php-restart
RUN chmod +x -R /usr/local/bin/*

COPY php.ini /etc/php7/php.ini
COPY www.conf /etc/php7/php-fpm.d/www.conf
COPY startup /startup

RUN chmod +x /startup \
 && mkdir -p /workspace
WORKDIR /workspace

CMD ["/startup"]