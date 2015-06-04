python -mplatform | grep Ubuntu && export APACHE_HOME=/etc/apache2 || export APACHE_HOME=/etc/httpd
python -mplatform | grep Ubuntu && export APACHE_ENV_FILE=/etc/apache2/apache2.conf || export APACHE_ENV_FILE=/etc/sysconfig/httpd
RAW=https://raw.githubusercontent.com/chembl/mychembl/master

sudo curl -o $APACHE_HOME/conf.d/launchpad.conf $RAW/configuration/launchpad.conf
sudo bash -c 'echo "export LD_LIBRARY_PATH=/home/chembl/rdkit/lib:$LD_LIBRARY_PATH" >> $APACHE_ENV_FILE'
sudo curl -o /etc/phppgadmin/apache.conf $RAW/configuration/mychembl_phppgadmin_httpd.conf
sudo curl -o /etc/apache2/conf.d/phppgadmin $RAW/configuration/mychembl_phppgadmin_httpd.conf
sudo curl -o /etc/php5/apache2/php.ini $RAW/configuration/mychembl_php.ini
sudo kill -9 $(pidof apache2)
sudo a2enmod rewrite
sudo service apache2 restart

wget $RAW/webservices/ws_cache_generation.sh && sh ws_cache_generation.sh
