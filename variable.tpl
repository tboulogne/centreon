# -*-Shell-script-*-
# SVN: $URL$
# SVN: $Id$

################################################## ###################
## Begin: Install modules
################################################## ###################
## What do you want to install ? 
## 0 = no, 1 = yes

## CentWeb: Web front Centreon for Nagios
PROCESS_CENTREON_WWW=1
## CentStorage: Log and charts archiving.
PROCESS_CENTSTORAGE=1
## CentCore: Distributed Monitoring engine.
PROCESS_CENTCORE=1
## CentPlugins: Centreon Plugins for nagios
PROCESS_CENTREON_PLUGINS=1
## CentTraps: Centreon Snmp traps process for nagios
PROCESS_CENTREON_SNMP_TRAPS=1
################################################## ###################
## End: Install modules
################################################## ###################


################################################## ###################
## Begin: Default variables
################################################## ###################
## Your default variables
## $BASE_DIR is the centreon source directory
LOG_DIR="$BASE_DIR/log"
LOG_FILE="$LOG_DIR/install_centreon.log"

## Don't change values above unless you perfectly understand 
## what you are doing.
## Centreon temporary directory to work
TMP_DIR="/tmp/centreon-setup"
## default snmp config directory
SNMP_ETC="/etc/snmp/"
## a list of pear modules require by Centreon
PEAR_MODULES_LIST="pear.lst"
## forge install pear module (1=yes/0=no)
PEAR_AUTOINST=1
## no root user can be install centreon
#FORCE_NO_ROOT=0
################################################## ###################
## End: Default variables
################################################## ###################


################################################## ###################
## Begin: Centreon preferences
################################################## ###################
## Above variables are necessary to run a silent install
## Where you want to install Centreon (Centreon root directory)
INSTALL_DIR_CENTREON="/usr/local/centreon"
## Centreon log files directory
CENTREON_LOG="/usr/local/centreon/log"
## Centreon config files
CENTREON_ETC="/etc/centreon"
BROKER_ETC="/etc/centreon"
BROKER_INIT_SCRIPT="/etc/init.d/cbd"
## Centreon run dir (all .pid, .run, .lock)
CENTREON_RUNDIR="/var/run/centreon/"
## Centreon generation config directory
## filesGeneration and filesUpload
CENTREON_GENDIR="/usr/local/centreon"
## CentStorage RRDs directory (where .rrd files go)
CENTSTORAGE_RRD="/var/lib/centreon"
## path to centstorage binary
CENTSTORAGE_BINDIR="/usr/local/centreon/bin"
CENTREON_BINDIR="/usr/local/centreon/bin"
## path to centcore binary
CENTCORE_BINDIR="/usr/local/centreon/bin"
## libraries temporary files directory
CENTREON_VARLIB="/var/lib/centreon/"
## Some plugins require temporary datas to process output.
## These temp datas are store in the CENTPLUGINS_TMP path.
CENTPLUGINS_TMP="/var/lib/centreon/centplugins"
CENTREON_DATADIR="/usr/local/centreon/data"
CENTREON_GROUP="centreon"
CENTREON_USER="centreon"
## path to centpluginsTraps binaries
CENTPLUGINSTRAPS_BINDIR="/usr/local/centreon/bin"
## path for snmptt installation
SNMPTT_BINDIR="/usr/sbin"
## force install init script (install in init.d)
## Set to "1" to enable
CENTCORE_INSTALL_INIT=1
CENTSTORAGE_INSTALL_INIT=1
## force install run level for init script (add all link on rcX.d)
## Set to "1" to enable
CENTCORE_INSTALL_RUNLVL=1
CENTSTORAGE_INSTALL_RUNLVL=1
################################################## ###################
## End: Centreon preferences
################################################## ###################


################################################## ###################
## Begin: Nagios preferences
################################################## ###################
## Install directory
INSTALL_DIR_NAGIOS="/usr/local/nagios"
## Configuration directory
MONITORINGENGINE_ETC="/usr/local/nagios/etc"
## Plugins directory
PLUGIN_DIR="/usr/local/nagios/libexec"
## Images (logos) directory
NAGIOS_IMG="/usr/local/nagios/share/images/logos"
## The nagios binary (optional)
MONITORINGENGINE_BINARY="/usr/local/nagios/bin/nagios"
## The nagiostats binary (optional)
NAGIOSTATS_BINARY="/usr/local/nagios/bin/nagiostats"
## Logging directory
NAGIOS_VAR="/usr/local/nagios/var"
## Nagios user (optional)
#NAGIOS_USER="nagios"
MONITORINGENGINE_USER="nagios"
## If you want to force NAGIOS_USER, set FORCE_NAGIOS_USER to 1 (optional)
FORCE_NAGIOS_USER=1
## Nagios group (optional)
NAGIOS_GROUP="nagiosgrp"
## If you want to force NAGIOS_GROUP, set FORCE_NAGIOS_GROUP to 1 (optional)
FORCE_NAGIOS_GROUP=1
## Nagios p1.pl file (perl embedded)
NAGIOS_P1_FILE="/usr/local/nagios/bin/p1.pl"
## If you want to not use NDO (not recommended)
#FORCE_NOT_USE_NDO=1
## Nagios NDO module
NDOMOD_BINARY="/usr/local/nagios/bin/ndomod.o"
## Nagios init script (optional)
MONITORINGENGINE_INIT_SCRIPT="/etc/init.d/nagios"
MONITORINGENGINE_LOG="/var/log/"

################################################## ###################
## End: Nagios preferences
################################################## ###################

################################################## ###################
## Begin: Apache preferences
################################################## ###################
## Apache configuration directory (optional)
DIR_APACHE="/etc/apache2"
## Apache local specific configuration directory (optional)
DIR_APACHE_CONF="/etc/apache2/conf.d"
## Apache configuration file. Only file name. (optional)
APACHE_CONF="apache2.conf"
## Apache user (optional)
WEB_USER="www-data"
## Apache group (optional)
WEB_GROUP="www-data"
## Force apache reload (optional): set APACHE_RELOAD to 1
APACHE_RELOAD=1
################################################## ###################
## End: Apache preferences
################################################## ###################

################################################## ###################
## Begin: Other binary
################################################## ###################
## RRDTOOL (optional)
BIN_RRDTOOL="/usr/bin/rrdtool"
## Mail (optional)
BIN_MAIL="/usr/bin/mail"
## SSH (optional)
BIN_SSH="/usr/bin/ssh"
## SCP (optional)
BIN_SCP="/usr/bin/scp"
## PHP (optional)
PHP_BIN="/usr/bin/php"
## GREP (optional)
#GREP=""
## CAT (optional)
#CAT=""
## SED (optional)
#SED=""
## CHMOD (optional)
#CHMOD=""
## CHOWN (optional)
#CHOWN
################################################## ###################
## End: Other binary
################################################## ###################


################################################## ###################
## Begin: Others
################################################## ###################
## Perl path for RRDs.pm file
RRD_PERL="/usr/lib/perl5"
## Path to sudoers file (optional)
SUDO_FILE="/etc/sudoers"
## Force sudo config (optional)
FORCE_SUDO_CONF=1
## Apache user (optional)
WEB_USER="www-data"
## Apache group (optional)
WEB_GROUP="www-data"
## init script directory (optional)
INIT_D="/etc/init.d"
## cron config script directory (optional)
CRON_D="/etc/cron.d"
## Path for PEAR.php file
PEAR_PATH="/usr/share/php"
################################################## ###################
## End: Others
################################################## ###################
