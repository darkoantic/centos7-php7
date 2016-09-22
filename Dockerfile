FROM centos/httpd:latest
MAINTAINER darkoantic

# Update and install latest packages and prerequisites
RUN yum clean all && yum makecache fast \
    && yum -y install https://mirror.webtatic.com/yum/el7/webtatic-release.rpm && yum -y update \
    && yum -y install git composer php70w php70w-opcache php70w-cli php70w-common php70w-mysql php70w-mbstring php70w-pecl-redis \
    && yum -y install tcping which && yum clean all


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
