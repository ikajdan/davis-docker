#!/bin/sh

# Exit immediately on error
set -e

# Termination function
stop_container()
{
    pkill php-fpm8
    nginx -s stop
    exit 0
}
trap stop_container SIGTERM

# Set the timezone
if [ -n "$TZ" ]; then
    printf '[Date]\ndate.timezone="%s"\n' "$TZ" > /etc/php8/conf.d/70_timezone.ini
fi

# Inject environment variables
if [ -n "$APP_ENV" ]; then
    echo "APP_ENV=$APP_ENV" >> /var/www/davis/.env.local
fi
if [ -n "$APP_SECRET" ]; then
    echo "APP_SECRET=$APP_SECRET" >> /var/www/davis/.env.local
fi
if [ -n "$TRUSTED_PROXIES" ]; then
    echo "TRUSTED_PROXIES=$TRUSTED_PROXIES" >> /var/www/davis/.env.local
fi
if [ -n "$TRUSTED_HOSTS" ]; then
    echo "TRUSTED_HOSTS=$TRUSTED_HOSTS" >> /var/www/davis/.env.local
fi
if [ -n "$DATABASE_URL" ]; then
    echo "DATABASE_URL=$DATABASE_URL" >> /var/www/davis/.env.local
fi
if [ -n "$MAILER_DSN" ]; then
    echo "MAILER_DSN=$MAILER_DSN" >> /var/www/davis/.env.local
fi
if [ -n "$ADMIN_LOGIN" ]; then
    echo "ADMIN_LOGIN=$ADMIN_LOGIN" >> /var/www/davis/.env.local
fi
if [ -n "$ADMIN_PASSWORD" ]; then
    echo "ADMIN_PASSWORD=$ADMIN_PASSWORD" >> /var/www/davis/.env.local
fi
if [ -n "$AUTH_REALM" ]; then
    echo "AUTH_REALM=$AUTH_REALM" >> /var/www/davis/.env.local
fi
if [ -n "$AUTH_METHOD" ]; then
    echo "AUTH_METHOD=$AUTH_METHOD" >> /var/www/davis/.env.local
fi
if [ -n "$IMAP_AUTH_URL" ]; then
    echo "IMAP_AUTH_URL=$IMAP_AUTH_URL" >> /var/www/davis/.env.local
fi
if [ -n "$IMAP_AUTH_USER_AUTOCREATE" ]; then
    echo "IMAP_AUTH_USER_AUTOCREATE=$IMAP_AUTH_USER_AUTOCREATE" >> /var/www/davis/.env.local
fi
if [ -n "$LDAP_AUTH_URL" ]; then
    echo "LDAP_AUTH_URL=$LDAP_AUTH_URL" >> /var/www/davis/.env.local
fi
if [ -n "$LDAP_DN_PATTERN" ]; then
    echo "LDAP_DN_PATTERN=$LDAP_DN_PATTERN" >> /var/www/davis/.env.local
fi
if [ -n "$LDAP_MAIL_ATTRIBUTE" ]; then
    echo "LDAP_MAIL_ATTRIBUTE=$LDAP_MAIL_ATTRIBUTE" >> /var/www/davis/.env.local
fi
if [ -n "$CALDAV_ENABLED" ]; then
    echo "CALDAV_ENABLED=$CALDAV_ENABLED" >> /var/www/davis/.env.local
fi
if [ -n "$CARDDAV_ENABLED" ]; then
    echo "CARDDAV_ENABLED=$CARDDAV_ENABLED" >> /var/www/davis/.env.local
fi
if [ -n "$WEBDAV_ENABLED" ]; then
    echo "WEBDAV_ENABLED=$WEBDAV_ENABLED" >> /var/www/davis/.env.local
fi
if [ -n "$INVITE_FROM_ADDRESS" ]; then
    echo "INVITE_FROM_ADDRESS=$INVITE_FROM_ADDRESS" >> /var/www/davis/.env.local
fi
if [ -n "$WEBDAV_TMP_DIR" ]; then
    echo "WEBDAV_TMP_DIR=$WEBDAV_TMP_DIR" >> /var/www/davis/.env.local
fi
if [ -n "$WEBDAV_PUBLIC_DIR" ]; then
    echo "WEBDAV_PUBLIC_DIR=$WEBDAV_PUBLIC_DIR" >> /var/www/davis/.env.local
fi
if [ -n "$MAPBOX_API_KEY" ]; then
    echo "MAPBOX_API_KEY=$MAPBOX_API_KEY" >> /var/www/davis/.env.local
fi

# It would be nice to automatically run
# `APP_ENV=prod bin/console doctrine:schema:create --no-interaction` if needed.

# Start PHP and Nginx
php-fpm8
exec nginx -g 'daemon off;'
