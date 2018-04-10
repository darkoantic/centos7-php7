FROM centos/httpd:latest
MAINTAINER darkoantic

COPY scripts/ /

# Update and install latest packages and prerequisites
RUN yum clean all && yum makecache fast \
    && yum -y install https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && yum -y update \
    && yum -y install git php71w-cli mod_php71w php71w-opcache php71w-common php71w-mysql php71w-mbstring php71w-pecl-redis php71w-gd \
    && yum -y install tcping which wget && yum clean all \
    && chmod +x /install-composer.sh && /install-composer.sh && rm /install-composer.sh \
    && mv /composer.phar /usr/bin/composer && chmod a+x /usr/bin/composer

COPY config/php.ini /etc/php.ini

# Setup SSH for checking out code from github
RUN echo "Setting up SSH for GitHub Checkouts..." && \
    mkdir -p /root/.ssh && chmod 700 /root/.ssh && \
    touch /root/.ssh/known_hosts && \
    ssh-keyscan -H github.com >> /root/.ssh/known_hosts && \
    chmod 600 /root/.ssh/known_hosts

EXPOSE 80
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-DFOREGROUND"]
