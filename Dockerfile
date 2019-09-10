FROM nginx:1.17.0-alpine

LABEL maintainer="yilu-zzb <zhouzhibin@yilu.co>"

COPY startup /startup
COPY .vimrc nvim_init.sh /root/

RUN sed -i 's|v3.9|edge|g' /etc/apk/repositories \  
 && apk update \
 && apk add neovim neovim-doc curl bash zsh \
 && mkdir -p /root/.config/nvim \
 && curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
 && mkdir -p /root/.config/nvim/colors \
 && ln -s /root/.vimrc /root/.config/nvim/init.vim \

 && cp /usr/share/zoneinfo/Asia/Chongqing /etc/localtime \

 && sed -i 's|edge|v3.9|g' /etc/apk/repositories \
 && apk update \

 && apk add openssh-client git make g++ \
            php7 \
            php7-fpm \
            php7-openssl \
            php7-pecl-msgpack \
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
            php7-pcntl \
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

 && git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
 && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
 && sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="yilu"|' /root/.zshrc \

 && curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer \
 && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \

 && sed -i '/*.conf;/a\    include /workspace/*/*/nginx.conf;' /etc/nginx/nginx.conf \
 && chmod +x /startup \
 && mkdir -p /workspace
 
COPY php.ini /etc/php7/php.ini
COPY www.conf /etc/php7/php-fpm.d/www.conf
COPY yilu.zsh-theme /root/.oh-my-zsh/themes/yilu.zsh-theme
COPY dracula.vim /root/.config/nvim/colors/

WORKDIR /workspace

CMD ["/startup"]
