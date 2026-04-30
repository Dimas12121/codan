#!/bin/bash

# CODean Laravel Backend Deployment Script
# For domain: codean.brodims.my.id

set -e

echo "🚀 Starting CODean Backend Deployment"
echo "📌 Target Domain: codean.brodims.my.id"
echo "=========================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "⚠️  Please run as root or with sudo"
    exit 1
fi

# Variables
DOMAIN="codean.brodims.my.id"
APP_DIR="/var/www/codean-backend"
NGINX_CONF="/etc/nginx/sites-available/codean"
NGINX_ENABLED="/etc/nginx/sites-enabled/codean"
PHP_VERSION="8.3"

echo "1. 📦 Installing required packages..."
apt update
apt install -y nginx mysql-server php${PHP_VERSION} php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysql php${PHP_VERSION}-mbstring php${PHP_VERSION}-xml \
    php${PHP_VERSION}-curl php${PHP_VERSION}-zip php${PHP_VERSION}-gd \
    composer certbot python3-certbot-nginx nodejs npm

echo "2. 🗂️  Creating application directory..."
mkdir -p $APP_DIR
chown -R $USER:$USER $APP_DIR
chmod -R 755 $APP_DIR

echo "3. 🔧 Configuring MySQL..."
mysql -e "CREATE DATABASE IF NOT EXISTS codean_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER IF NOT EXISTS 'codean_user'@'localhost' IDENTIFIED BY 'Codean@123';"
mysql -e "GRANT ALL PRIVILEGES ON codean_db.* TO 'codean_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

echo "4. ⚙️  Configuring PHP-FPM..."
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 10M/" /etc/php/${PHP_VERSION}/fpm/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 10M/" /etc/php/${PHP_VERSION}/fpm/php.ini
systemctl restart php${PHP_VERSION}-fpm

echo "5. 🌐 Configuring Nginx..."
cat > $NGINX_CONF << EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    root $APP_DIR/public;
    index index.php index.html index.htm;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php${PHP_VERSION}-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)\$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

ln -sf $NGINX_CONF $NGINX_ENABLED
nginx -t
systemctl reload nginx

echo "6. 🔐 Getting SSL Certificate..."
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@brodims.my.id

echo "7. 📁 Setting up Laravel application..."
echo "📝 Note: Please manually copy your Laravel files to $APP_DIR"
echo "📝 Then run: cd $APP_DIR && composer install"
echo "📝 Then run: cp .env.production .env && nano .env"
echo "📝 Then run: php artisan key:generate"
echo "📝 Then run: php artisan migrate --force"

echo "8. 🔧 Final permissions..."
chown -R www-data:www-data $APP_DIR
chmod -R 755 $APP_DIR/storage
chmod -R 755 $APP_DIR/bootstrap/cache

echo "✅ Deployment script completed!"
echo "=========================================="
echo "Next steps:"
echo "1. Copy Laravel files to $APP_DIR"
echo "2. Configure .env file with database credentials"
echo "3. Run: php artisan migrate --force"
echo "4. Test at: https://$DOMAIN"
echo "5. API endpoint: https://$DOMAIN/api"
echo "=========================================="