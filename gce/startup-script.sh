set -e
export HOME=/root
APP_NAME=php-sandbox
GITHUB_ID=chck

# Install PHP and dependencies from apt
apt-get update
apt-get install -y git nginx php7.2 php7.2-fpm php7.2-mysql php7.2-dev \
    php7.2-mbstring php7.2-zip php-pear pkg-config

# Install Composer
curl -sS https://getcomposer.org/installer | \
    /usr/bin/php -- \
    --install-dir=/usr/local/bin \
    --filename=composer

# Get the application source code
#git clone https://github.com/googlecloudplatform/getting-started-php /opt/src
git clone https://github.com/$GITHUB_ID/$APP_NAME /opt/src
ln -s /opt/src /opt/app

# Run Composer
composer install -d /opt/app --no-ansi --no-progress --no-dev

# Disable the default NGINX configuration
rm /etc/nginx/sites-enabled/default

# Enable our NGINX configuration
#cp /opt/app/config/nginx/helloworld.conf /etc/nginx/sites-available/helloworld.conf
#ln -s /etc/nginx/sites-available/helloworld.conf /etc/nginx/sites-enabled/helloworld.conf
cp /opt/app/config/nginx/$APP_NAME.conf /etc/nginx/sites-available/$APP_NAME.conf
ln -s /etc/nginx/sites-available/$APP_NAME.conf /etc/nginx/sites-enabled/$APP_NAME.conf
cp /opt/app/config/nginx/fastcgi_params /etc/nginx/fastcgi_params

# Start NGINX
systemctl restart nginx.service

# Install Fluentd
curl -s "https://storage.googleapis.com/signals-agents/logging/google-fluentd-install.sh" | bash

# Enable our Fluentd configuration
cp /opt/app/config/fluentd/$APP_NAME.conf /etc/google-fluentd/config.d/$APP_NAME.conf

# Start Fluentd
service google-fluentd restart &
