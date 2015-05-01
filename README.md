centreon
========

Modify the original script to work on debian/ubuntu.
Add variables for version of scripts :

Current are :
```
NAGIOS_VERSION=nagios-4.1.0rc1
NAGIOS_VERSION_SHORT=nagios-4.1.0
NAGIOS_PLUGIN_VERSION=2.0.3
CENTREON_VERSION=2.6.0
NDOUTILS_VERSION=2.0.0
````

Add centreon template variables file facilities. Modify last line of install.sh, if you don't wand to use it.

````
do_with_root ./install.sh -i -f $VARIABLE_FILE_PATH/variables.tmpl
````
Centreon install script

How to use:
````
git clone
cd centreon
sudo ./install.sh
````
	
