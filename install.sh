#!/bin/sh

# Centreon install script by Denis Gourmel (nesousx) ;
# credits goes to Nicolargo

### User variables (modify this according to your needs)

NAGIOS_VERSION=nagios-4.1.0rc1 
NAGIOS_VERSION_SHORT=nagios-4.1.0
NAGIOS_PLUGIN_VERSION=2.0.3

NAGIOS_WEB_PASSWD=plop        #password for nagois web admin, in plain text

NAGIOS_PASSWD_CLEAR=plop      #password for nagios user

NAGIOS_CORE=http://netcologne.dl.sourceforge.net/project/nagios/nagios-4.x/$NAGIOS_VERSION_SHORT/$NAGIOS_VERSION.tar.gz                  #URL of nagios core archive

NAGIOS_PLUGINS=http://nagios-plugins.org/download/nagios-plugins-$NAGIOS_PLUGIN_VERSION.tar.gz  #URL of nagios plugis archive
#Not working ---> must use a function, pass is 'plop' NDO_PASSWORD=plop              #NDO db password

NDOUTILS=http://sourceforge.net/projects/nagios/files/ndoutils-1.x/ndoutils-1.5.2/ndoutils-1.5.2.tar.gz

CENTREON=http://download.centreon.com/index.php?id=4264                       # Centreon download URL

NDO2DB=https://raw.github.com/Nesousx/centreon/master/ndo2db                   #NDO2DB init script

### Script variables (only modify this if you know what you are doing)

NAGIOS_PASSWD_CRYPT=$(perl -e 'print crypt($ARGV[0], "password")' $NAGIOS_PASSWD_CLEAR)
PWD=`pwd`

### Set up environnemnt

do_with_root() {
        # already root? "Just do it" (tm).
        if [ `whoami` = 'root' ] ; then
            $*
        elif [ -x /bin/sudo -o -x /usr/bin/sudo ] ; then
            echo
            echo "Sudo detected, Installation will request root privileges to"
            echo "install. You may be prompted for a password. If you prefer to not use"
            echo "sudo, please re-run this script as root."
            echo "sudo $*"
            sudo $*
        else
            echo "Installation requires root privileges to install. Please re-run this script as"
            echo "root."
            exit 1
        fi
    }

### Install prerequisites

echo "***** Installing of prereqisites *****"
do_with_root apt-get update
do_with_root apt-get -y upgrade
do_with_root apt-get -y install build-essential sudo apache2 wget rrdtool bsd-mailx librrds-perl libapache2-mod-php5 php5 php-pear php5-gd php5-ldap php5-snmp libperl-dev rrdtool librrds-perl bind9-host dnsutils bind9utils libradius1 qstat radiusclient1 snmp snmpd libgd2-xpm-dev libpng12-dev libjpeg62 mysql-server php5-mysql libmysqlclient15-dev fping libnet-snmp-perl libldap-dev libmysqlclient-dev libgnutls-dev libradiusclient-ng-dev
echo "***** Done with prerequisites *****"

### Create users

echo "**** Creating users *****"
do_with_root /usr/sbin/useradd nagios -p $NAGIOS_PASSWD_CRYPT
do_with_root /usr/sbin/usermod -G nagios nagios
do_with_root /usr/sbin/usermod -G nagios www-data
echo "***** Done with users *****"

### Nagios

	## Core
cd /usr/src
echo "***** Downloading $NAGIOS_CORE to $PWD *****"
do_with_root wget $NAGIOS_CORE 
echo "***** Extracting Nagios *****"
do_with_root tar xzf nagios-*
cd $NAGIOS_VERSION
echo "***** Configuration and compilation of Nagios core *****"
./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-command-user=nagios --with-command-group=nagios --enable-event-broker --enable-nanosleep --enable-embedded-perl --with-perlcache
do_with_root make all
do_with_root make fullinstall
do_with_root make install-config
echo "***** Done compiling *****"
do_with_root ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios
APT=apt-get -y

do_with_root htpasswd -c /usr/local/nagios/etc/
do_with_root /etc/init.d/apache2 reload

	## Plugins
cd /usr/src
echo "***** Downloading $NAGIOS_PLUGINS to $PWD *****"
do_with_root wget $NAGIOS_PLUGINS
echo "***** Extracting Nagios *****"
do_with_root tar xzf nagios-plugins*
cd nagios-plugins-$NAGIOS_PLUGIN_VERSION
echo "***** Compiling and installing Nagios plugins *****"
./configure --with-nagios-user=nagios --with-nagios-group=nagios
do_with_root make
do_with_root make install
echo "***** Done compiling *****"
echo "***** Checking nagios config *****"
do_with_root /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
do_with_root /etc/init.d/nagios start
echo "Nagios installation done, check it at http://YOURIP/nagios/"


### Centreon

	## Creating NDO table and user
echo "***** Creating MySQL NDO table, and NDO user ****"
mysqladmin -u root -p create ndo
mysql -u root -h localhost -p -Bse 'GRANT ALL ON ndo.* TO "ndo"@"localhost" IDENTIFIED BY "plop"'

cd /usr/src
echo "***** Downloading NDOUtils *****"
do_with_root wget -O ndoutils.tar.gz $NDOOUTILS
echo "***** Extracting NDOUtils *****"
do_with_root tar xzf ndoutils.tar.gz
cd ndoutils*
echo "****** Configuring and compiling NDOUtils *****"
./configure --disable-pgsql --with-mysql-lib=/usr/lib/mysql --with-ndo2db-user=nagios --with-ndo2db-group=nagios
do_with_root make
echo "***** Done compiling *****"
do_with_root cp src/ndomod-3x.o /usr/local/nagios/bin/ndomod.o
do_with_root cp src/ndo2db-3x /usr/local/nagios/bin/ndo2db
do_with_root echo "event_broker_options=-1" >> /usr/local/nagios/etc/nagios.cfg
do_with_root echo "broker_module=/usr/local/nagios/bin/ndomod.o config_file=/usr/local/nagios/etc/ndomod.cfg" >> /usr/local/nagios/etc/nagios.cfg

	# Copy ndomod
do_with_root cp config/ndomod.cfg-sample /usr/local/nagios/etc/ndomod.cfg
	# Modify ndomod
do_with_root echo "instance_name=Central" >> /usr/local/nagios/etc/ndomod.cfg
do_with_root echo "output_type=unixsocket" >> /usr/local/nagios/etc/ndomod.cfg
do_with_root echo "output=/usr/local/nagios/var/ndo.sock" >> /usr/local/nagios/etc/ndomod.cfg
do_with_root echo "tcp_port=5668" >> /usr/local/nagios/etc/ndomod.cfg
do_with_root echo "output_buffer_items=5000" >> /usr/local/nagios/etc/ndomod.cfg
do_with_root echo "buffer_file=/usr/local/nagios/var/ndomod.tmp" >> /usr/local/nagios/etc/ndomod.cfg

	# Copy ndo2db
do_with_root cp config/ndo2db.cfg-sample /usr/local/nagios/etc/ndo2db.cfg
	# Modify ndo2db
do_with_root echo "ndo2db_user=nagios" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "ndo2db_group=nagios" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "socket_type=unix" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "socket_name=/usr/local/nagios/var/ndo.sock" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "tcp_port=5668" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "db_servertype=mysql" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "db_host=localhost" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "db_name=ndo" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "db_port=3306" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "db_prefix=nagios_" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "db_user=ndo" >> /usr/local/nagios/etc/ndo2db.cfg
do_with_root echo "db_pass=plop" >> /usr/local/nagios/etc/ndo2db.cfg

do_with_root chmod 774 /usr/local/nagios/bin/ndo* 
do_with_root chown nagios:nagios /usr/local/nagios/bin/*
do_with_root chown nagios:nagios /usr/local/nagios/etc/ndo*

	### Initialisation db
cd db
do_with_root ./installdb -u ndo -p plop -h localhost -d ndo

do_with_root wget -O /etc/init.d/ndo2db $NDO2DB
do_with_root chown root:root /etc/init.d/ndo2db
do_with_root chmod 755 /etc/init.d/ndo2db
do_with_root update-rc.d ndo2db defaults
do_with_root /etc/init.d/ndo2db start

do_with_root /etc/init.d/nagios restart

	### Récupération Centreon
cd /usr/src
do_with_root wget -O centreon.tar.gz $CENTREON
do_with_root tar xzf centreon.tar.gz
cd centreon*

	### Installation Centreon
do_with_root ./install.sh -i
