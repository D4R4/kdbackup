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

#Usage
