# kdbackup
bash shell script to create a compressed backup file from folder and mysql database

Author: Mohammed AlShannaq , http://shannaq.com

git repository for this project are located in https://github.com/shannaq/kdbackup

#What is kdbackup bash script

kdbackup bash script was created to cover special case when we need to take a backup from one folder contents and one mysql database contents.

Sometimes may be we are running our website in a linux server that did not have any control panel like CPanel also there is no backup software that take a daily or weekly backup and we need to create a backup from our website content (public_html folder for example) and our MySQL database content. in this case you can use kdbackup as alternative simple backup script that can create a daily, schedule or on the fly backup from your website contents.

#Installing

Download the last version of kdbackup from github from the following link https://github.com/shannaq/kdbackup/archive/master.zip and unzip the file into the 
location where you want to store the kdbackup files or by using the following commands after log in to SSH

```
$ cd ~
$ wget https://github.com/shannaq/kdbackup/archive/master.zip
$ unzip master.zip
$ mv kdbackup-master kdbackup
$ rm master.zip
$ cd kdbackup
```

If you do a list file command you can see 3 files which is: 

```
cfgfile.cfg
kdbackup.sh
README.md
```

**README.md**: this is the help file which contains the current instructions and documentation

**kdbackup.sh**: is the main kdbackup bash script which must call when we need to create a backup.

**cfgfile.cfg**: is a sample config file that the kdbackup.sh used to create the backup file. the config fil contains the basic information that the script need.

## cfgfile.cfg

You must edit the config file **cfgfile.cfg** and change the varibales value to fit your website information **Please note** that this file is bash file and not 
a real config file, so when changing variables values make sure to follow bash rules. NO space between var and val also no empty lines at the end of lines.

You must specify the website content folder in *cfg_contents_folder* variable which may be (/home/user/public_html) for example. And if you want t create backup 
of your mysql database you must keep *cfg_mysqldump* variable value to 1. else if you do not want to create a backup of any mysql database change the value of 
the variable *cfg_mysqldump* to 0 and if you choose to backup mysql databse you have to specify the correct database information as *cfg_mysql_databasename* the 
database name, *cfg_mysql_databaseusername* as the database username and *cfg_mysql_databaseusernamepassword* as the database user password.

Also you can add prefix to the backup file name by specify any profix in the *cfg_backupfile_prefix* variable. finally you have to choose where to store the generated backup 
file in the *cfg_backup_dest* variable.
