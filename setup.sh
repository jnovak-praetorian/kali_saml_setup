#!/bin/sh -x

if [ `id -u` -ne 0 ]
then
    echo 'Need to run as root'
    exit 0
fi

read -p "What is the hostname? " HOSTNAME
echo "Using hostname $HOSTNAME"

apt-get update && apt-get install -y apache2 simplesamlphp php-xml php-curl php-mbstring php-memcache

######################

echo 'Enabling SSL on server'
if [ ! -f /etc/ssl/certs/kali_saml.crt ]
then
    openssl req -newkey rsa:2048 -new -x509 -days 3652 -nodes -out /etc/ssl/certs/kali_saml.crt -keyout /etc/ssl/certs/kali_saml.key
    chmod 644 /etc/ssl/certs/kali_saml.key
fi

a2enmod ssl
cp ./conf/apache.conf /etc/simplesamlphp/apache.conf
a2enconf simplesamlphp

######################

echo 'Enabling logging in simplesamlphp'
sed -i "s/'saml' => false,/'saml' => true,/g" /etc/simplesamlphp/config.php
sed -i "s/'backtraces' => false,/'backtraces' => true,/g" /etc/simplesamlphp/config.php
sed -i "s/'validatexml' => false,/'validatexml' => true,/g" /etc/simplesamlphp/config.php
sed -i "s/'logging.level' => SimpleSAML\Logger::NOTICE,/'logging.level' => SimpleSAML\Logger::DEBUG,/g" /etc/simplesamlphp/config.php
sed -i "s/'logging.handler' => 'syslog',/'logging.handler' => 'file',/g" /etc/simplesamlphp/config.php

######################

echo 'Configuring SAML20'

sed -i "s/'enable.saml20-idp' => false,/'enable.saml20-idp' => true,/g" /etc/simplesamlphp/config.php
cp ./conf/saml20-idp-remote.php /etc/simplesamlphp/metadata/
cp ./conf/saml20-idp-hosted.php /etc/simplesamlphp/metadata/
cp ./conf/saml20-sp-remote.php /etc/simplesamlphp/metadata/
sed -i "s/HOSTNAME/$HOSTNAME/g" /etc/simplesamlphp/metadata/saml20-idp-remote.php
sed -i "s/HOSTNAME/$HOSTNAME/g" /etc/simplesamlphp/metadata/saml20-sp-remote.php
touch /usr/share/simplesamlphp/modules/exampleauth/enable
cp ./conf/authsources.php /etc/simplesamlphp/

######################

echo -e "\n\nTest the default-sp authentication source here: https://$HOSTNAME/simplesamlphp/module.php/core/authenticate.php\n\nTest IdP-initiated login here: https://$HOSTNAME/simplesamlphp/saml2/idp/SSOService.php?spentityid=https://$HOSTNAME/simplesamlphp/module.php/saml/sp/metadata.php/default-sp&RelayState=https://$HOSTNAME/simplesamlphp/module.php/core/authenticate.php?as=default-sp\n\n"

echo "Your admin password is below:"
cat /var/lib/simplesamlphp/secrets.inc.php

echo 'Finishing up'
service apache2 restart

