#!/bin/bash

# Bash shell script for generating self-signed certs. Run this in a folder, as it
# generates a few files. Large portions of this script were taken from the
# following artcile:
# 
# http://usrportage.de/archives/919-Batch-generating-SSL-certificates.html
# 
# Additional alterations by: Brad Landers
# Date: 2012-01-27
# usage: ./gen_cert.sh example.com

# Script accepts a single argument, the fqdn for the cert
DOMAIN="fmc-satya.com"
SSLDOMAIN="fmc-satya.com"
DOCUMENT_ROOT="/var/www/html/$DOMAIN"
SSL_CERT_FILE="/etc/ssl/certs/$DOMAIN.crt"
SSL_KEY_FILE="/etc/ssl/certs/$DOMAIN.key"

if [ -z "$DOMAIN" ]; then
  echo "Usage: $(basename $0) <domain>"
  exit 11
fi

fail_if_error() {
  [ $1 != 0 ] && {
    unset PASSPHRASE
    exit 10
  }
}

apt-get update -y
apt-get install -y apache2
ufw allow 'Apache Full'
a2enmod ssl
systemctl restart apache2
mkdir -p /etc/ssl/certs
cd /etc/ssl/certs/
# Generate a passphrase
export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)

# Certificate details; replace items in angle brackets with your own info
subj="
C=US
ST=OR
O=Blah
localityName=Portland
commonName=$DOMAIN
organizationalUnitName=Blah Blah
emailAddress=admin@example.com
"

# Generate the server private key
openssl genrsa -des3 -out $DOMAIN.key -passout env:PASSPHRASE 2048
fail_if_error $?

# Generate the CSR
openssl req \
    -new \
    -batch \
    -subj "$(echo -n "$subj" | tr "\n" "/")" \
    -key $DOMAIN.key \
    -out $DOMAIN.csr \
    -passin env:PASSPHRASE
fail_if_error $?
cp $DOMAIN.key $DOMAIN.key.org
fail_if_error $?

# Strip the password so we don't have to type it every time we restart Apache
openssl rsa -in $DOMAIN.key.org -out $DOMAIN.key -passin env:PASSPHRASE
fail_if_error $?

# Generate the cert (good for 10 years)
openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt
fail_if_error $?


# Create SSL virtual host configuration file
echo "<VirtualHost *:443>" >> /etc/apache2/sites-available/$SSLDOMAIN.conf
echo "    ServerName $DOMAIN" >> /etc/apache2/sites-available/$SSLDOMAIN.conf
echo "    ServerAlias *.$DOMAIN" >> /etc/apache2/sites-available/$SSLDOMAIN.conf
echo "    DocumentRoot $DOCUMENT_ROOT" >> /etc/apache2/sites-available/$SSLDOMAIN.conf
echo "    SSLEngine On" >> /etc/apache2/sites-available/$SSLDOMAIN.conf
echo "    SSLCertificateFile $SSL_CERT_FILE" >> /etc/apache2/sites-available/$SSLDOMAIN.conf
echo "    SSLCertificateKeyFile $SSL_KEY_FILE" >> /etc/apache2/sites-available/$SSLDOMAIN.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/$SSLDOMAIN.conf



# Create virtual host configuration file
echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/$DOMAIN.conf
echo "    ServerName $DOMAIN" >> /etc/apache2/sites-available/$DOMAIN.conf
echo "    ServerAlias *.$DOMAIN" >> /etc/apache2/sites-available/$DOMAIN.conf
echo "    DocumentRoot $DOCUMENT_ROOT" >> /etc/apache2/sites-available/$DOMAIN.conf
echo '    <Location "/">' >> /etc/apache2/sites-available/$DOMAIN.conf
echo '      Redirect permanent "https://%{HTTP_HOST}%{REQUEST_URI}"' >> /etc/apache2/sites-available/$DOMAIN.conf
echo "   </Location>" >> /etc/apache2/sites-available/$DOMAIN.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/$DOMAIN.conf



# Create Index page for webapp
echo "<html>" >> /var/www/html/$DOMAIN/index.html
echo "<head><title>Hello World</title></head>" >> /var/www/html/$DOMAIN/index.html
echo "<body><h1>Hello World!</h1></body> >> /var/www/html/$DOMAIN/index.html
echo "</html> >> /var/www/html/$DOMAIN/index.html

# Enable the site and restart Apache
sudo a2ensite $DOMAIN
sudo a2ensite $SSLDOMAIN
sudo systemctl restart apache2
