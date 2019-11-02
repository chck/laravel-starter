set -e
export HOME=/root

# Install PHP and dependencies from apt
apt-get update
apt-get install -y git nginx php7.2 php7.2-fpm php7.2-mysql php7.2-dev \
    php7.2-mbstring php7.2-zip php-pear pkg-config docker.io 

# Start Docker
systemctl start docker && systemctl enable docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Composer
curl -sS https://getcomposer.org/installer | \
    /usr/bin/php -- \
    --install-dir=/usr/local/bin \
    --filename=composer
