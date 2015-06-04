python -mplatform | grep Ubuntu && export APACHE_HOME=/etc/apache2 || export APACHE_HOME=/etc/httpd
python -mplatform | grep Ubuntu && export APACHE_ENV_FILE=/etc/apache2/envvars || export APACHE_ENV_FILE=/etc/sysconfig/httpd
python -mplatform | grep Ubuntu && export APACHE_EXPORT="export " || export APACHE_EXPORT=
python -mplatform | grep Ubuntu && export APACHE_NAME="apache2" || export APACHE_NAME="httpd"
python -mplatform | grep Ubuntu && export AUX_OS_NAME="Ubuntu" || export AUX_OS_NAME="CentOS"
python -mplatform | grep Ubuntu && export AUX_CONF="" || export AUX_CONF=".conf"
python -mplatform | grep Ubuntu && export PHPPGADMIN="phppgadmin" || export PHPPGADMIN="phpPgAdmin"
RAW=https://raw.githubusercontent.com/chembl/mychembl/master

sudo -E curl -o $APACHE_HOME/conf.d/launchpad.conf $RAW/configuration/launchpad.conf
sudo -E bash -c 'echo "${APACHE_EXPORT}LD_LIBRARY_PATH=/home/chembl/rdkit/lib:\$LD_LIBRARY_PATH" >> ${APACHE_ENV_FILE}'
sudo -E curl -o /etc/$PHPPGADMIN/config.inc.php $RAW/configuration/phppgadmin_config.inc.php
sudo -E curl -o /etc/$APACHE_NAME/conf.d/${PHPPGADMIN}${AUX_CONF} $RAW/configuration/phppgadmin_${AUX_OS_NAME}.conf

sudo curl -o /etc/php5/apache2/php.ini $RAW/configuration/mychembl_php.ini
sudo kill -9 $(pidof apache2)
sudo a2enmod rewrite
sudo service apache2 restart

wget $RAW/webservices/ws_cache_generation.sh && sh ws_cache_generation.sh
