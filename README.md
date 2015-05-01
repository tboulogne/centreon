centreon
========

Modify the original script (https://github.com/Nesousx/centreon) to work on debian/ubuntu 14.04 and make some fonctional changes:

Add variables for version of scripts, currents are :
```
NAGIOS_VERSION=nagios-4.1.0rc1
NAGIOS_VERSION_SHORT=nagios-4.1.0
NAGIOS_PLUGIN_VERSION=2.0.3
CENTREON_VERSION=2.6.0
NDOUTILS_VERSION=2.0.0
````

Add centreon template variables file facilities. (Modify last line of install.sh, if you don't wand to use it.)

````
do_with_root ./install.sh -i -f $VARIABLE_FILE_PATH/variables.tmpl
````

How to use:
````
git clone https://github.com/tboulogne/centreon.git
cd centreon
sudo ./install.sh
````
	
