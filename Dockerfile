FROM alpine:3.16

ARG VERSION

RUN apk --no-progress add --no-cache \
        composer nginx php8 php8-ctype php8-dom php8-fpm php8-imap php8-intl \
        php8-ldap php8-pdo php8-pdo_mysql php8-pdo_pgsql php8-pdo_sqlite \
        php8-session php8-simplexml php8-tokenizer php8-xml php8-xmlreader php8-gd \
        php8-xmlwriter && \
    mv /etc/php8/php-fpm.d/www.conf /etc/php8/php-fpm.d/50-www.conf && \
    sed -i 's|nobody:x:65534:65534:nobody:/:/sbin/nologin|nobody:x:65534:65534:nobody:/:/bin/sh|' /etc/passwd && \
    wget --quiet --output-document davis.tar.gz \
         "https://github.com/tchapi/davis/archive/refs/tags/v${VERSION}.tar.gz" && \
    tar xzf davis.tar.gz && \
    rm davis.tar.gz && \
    mv "davis-${VERSION}" /var/www/davis && \
    cd /var/www/davis && \
    rm -r _screenshots .github docker .dockerignore .gitignore phpunit.xml.dist LICENSE README.md && \
    mkdir -p /data/webdav && \
    chown -R nobody:nobody /var/www/davis /data

COPY doctrine.yaml /var/www/davis/config/packages/doctrine.yaml

RUN cd /var/www/davis && \
    sed -i 's|mysql://davis:davis@127.0.0.1:3306/davis|sqlite:///%kernel.project_dir%/var/data.db|' .env && \
    su -c 'APP_ENV=prod composer install --no-ansi --no-dev --no-progress --optimize-autoloader --no-interaction --no-cache' nobody && \
    apk --no-progress del --no-cache composer

COPY nginx.conf /etc/nginx/http.d/default.conf
COPY php-fpm.conf /etc/php8/php-fpm.d/10-log.conf
COPY www-overrides.conf /etc/php8/php-fpm.d/55-www-overrides.conf
COPY docker-entrypoint.sh /
COPY favicon.ico /var/www/davis/public/

WORKDIR /var/www/davis

VOLUME /data

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]

HEALTHCHECK CMD wget --quiet --output-document /dev/null 127.0.0.1:8080
