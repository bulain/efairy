FROM debian:11
WORKDIR /var/www
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y apache2 php7.4 php7.4-curl git zip unzip sudo composer && \
    rm -rf /var/lib/apt/lists/* && \
    a2enmod rewrite && \
    rm -f /etc/apache2/sites-enabled/*
COPY docker /etc/apache2/sites-enabled/
COPY server /var/www/
RUN useradd -m debian && \
    chown -R debian  /var/www/ && \
    sudo -u debian composer config repo.packagist composer https://mirrors.aliyun.com/composer/ && \
    sudo -u debian composer update && \
    sudo -u debian composer install
ENV APACHE_RUN_DIR=/var/run/apache2 \
   APACHE_RUN_USER=www-data \
   APACHE_RUN_GROUP=www-data \
   APACHE_PID_FILE=/var/run/apache2/apache2.pid \
   APACHE_LOCK_DIR=/var/lock/apache2 \
   APACHE_LOG_DIR=/var/log/apache2
EXPOSE 80
CMD ["apache2", "-DFOREGROUND"]