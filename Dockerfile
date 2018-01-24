FROM centos/httpd:latest
MAINTAINER darkoantic

COPY scripts/ /

# Update and install latest packages and prerequisites
RUN yum clean all && yum makecache fast \
    && yum -y install https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && yum -y update \
    && yum -y install git php71w-cli mod_php71w.x86_64 php71w-opcache php71w-common php71w-mysql php71w-mbstring php71w-pecl-redis \
    && yum -y install php71w-pecl-xdebug.x86_64 \
    && yum -y install tcping which wget && yum clean all \
    && chmod +x /install-composer.sh && /install-composer.sh && rm /install-composer.sh \
    && mv /composer.phar /usr/bin/composer && chmod a+x /usr/bin/composer

COPY config/php.ini /etc/php.ini

# Setup SSH for checking out code from github
RUN echo "Setting up SSH for GitHub Checkouts..." \
    && mkdir -p /root/.ssh && chmod 700 /root/.ssh \
    && touch /root/.ssh/known_hosts \
    && ssh-keyscan -H github.com >> /root/.ssh/known_hosts \
    && chmod 600 /root/.ssh/known_hosts \
    && echo "xdebug.remote_enable=1" >> /etc/php.d/xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /etc/php.d/xdebug.ini \
    && echo "xdebug.remote_host=172.16.17.18" >> /etc/php.d/xdebug.ini \
    && echo "xdebug.remote_port=9001" >> /etc/php.d/xdebug.ini \
    && echo "xdebug.remote_log=\"/var/log/xdebug/xdebug.log\"" >> /etc/php.d/xdebug.ini \
    && mkdir /var/log/xdebug \
    && touch /var/log/xdebug/xdebug.log \
    && chmod 777 -R /var/log/xdebug/xdebug.log

EXPOSE 80
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-DFOREGROUND"]
