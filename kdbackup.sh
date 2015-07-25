#!/bin/bash
wipe="\033[1m\033[0m"
yellow="\E[1;33m"
red="\E[1;31m"
green="\E[1;32m"
if [ -z $1 ]; then
	cfg="cfgfile.cfg"
else
	cfg=$1
fi
today_date=`date +"%d%b%Y"`
echo ""
echo "kdbackup bash script"
echo "ver 0.1"
echo "author: Mohammed AlShannaq"
echo "http://shannaq.com"
echo
echo "Usage: kdbackup.sh [cfgfile path]"
echo ""



echo -n "Loading config file .. "
if [ ! -f "$cfg" ]; then
        #cfg file not exists
        echo -e "${yellow}Config file $cfg not exists. please refer or the manual${wipe}"
        exit 1
fi
echo -e "..${green}Loaded${wipe}"


source $cfg
backupfile=$cfg_backupfile_prefix$today_date
backupfile_tar="$backupfile.tar"
backupfile_name="$backupfile.tar.gz"
BD=$cfg_backup_dest


#checking  the destination folder
echo -n "Checking backup destination folder $BD .. "
if [  ! -d "$BD" ]; then
        #backup destination folder not exists
        echo -e "${yellow}Backup destination folder not exists .. please check your config${wipe}"
	echo -e "${red}Exit backup process!${wipe}"
        exit 1
fi


#checking the backupfile_name is exists for the current format or not
if [  ! -w "$BD" ]; then
        #backup destination folder not exists
        echo -e "${yellow}Backup destination folder is not writable .. please make sure from the directory is writable${wipe}"
	echo -e "${red}Exit backup process!${wipe}"
        exit 1
fi
echo -e "..${green}OK${wipe}"


#check the contents folder are exists or not
echo -n "Checking content folder $cfg_contents_folder .. "
if [ ! -d $cfg_contents_folder ]; then
	# Control will enter here if $DIRECTORY exists.	
	echo -e "${yellow}Contents folder not exists .. please check your config${wipe}"
	echo -e "${red}Exit backup process!${wipe}"
	exit 1
fi
echo -e "..${green}OK${wipe}"

echo -n "Checking backup file $cfg_backup_dest/$backupfile_name .."
#check if the backupfile exists or not to avoid ovwerwrite
if [  -f "$cfg_backup_dest/$backupfile_name" ]; then
        #backup destination folder not exists
        echo -e "${yellow}Backup filename $cfg_backup_dest/$backupfile_name already exists${wipe}"
	echo -e "${red}Exit backup process!${wipe}"
        exit 1
fi
echo -e "..${green}OK${wipe} Not exists"

#check if mysql database will be dumped
if [ $cfg_mysqldump == "1" ]; then
	mysql_dump_text="and mysql database $cfg_mysql_databasename "	
fi



#confirm user
echo
echo -e "${green}Create a new backup from folder content  $cfg_contents_folder $mysql_dump_text to $cfg_backup_dest/$backupfile_name${wipe}"
read -p "Are you sure? [Y=yes/N=no] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 2
fi


#create the tarfile from folder content	
full_tar_filename="${cfg_backup_dest}/${backupfile_tar}"
echo -n "Creating $full_tar_filename .. "
#get the basename to avoid include parent folders of the folder c http://unix.stackexchange.com/questions/41543/i-want-to-tar-x-directory-not-including-its-parents
#foldername
tarbanename=`basename $cfg_contents_folder`
#path
tardirname=`dirname $cfg_contents_folder`
tar -cf  "$full_tar_filename" -C $tardirname $tarbanename
rc=$?;
if [[ $rc != 0 ]]; then 
echo -e "${red}creating tarball from content folder faild ... Exit without complete!${wipe}"
exit $rc;
 fi
echo -e "${green}tar file has been created${wipe}"


#dump mysqldatabase to file
echo -n "Dumping mysql database $cfg_mysql_databasename to a file .. "
if [ $cfg_mysqldump == "1" ]; then
	sqlfile=$BD/$cfg_mysql_databasename$today_date.sql
	mysqldump -u$cfg_mysql_databaseusername -p$cfg_mysql_databaseusernamepassword  $cfg_mysql_databasename >  $sqlfile
	rc=$?;
	if [[ $rc != 0 ]]; then
		echo -e "${red}dumping mysql database to sql file faild ... Exit without complete!${wipe}"
		exit $rc;
	 fi
	echo -e "${green}Done.${wipe}"
	#adding the sql file to the tar file
	echo -n "Adding sql file to the tarball archive .. "
	#foldername
	tarbanename=`basename $sqlfile`
	#path
	tardirname=`dirname $sqlfile`
	echo "dir $tardirname base  $tarbanename"
	tar -rf  "$full_tar_filename" -C $tardirname $tarbanename
	if [[ $rc != 0 ]]; then
                echo -e "${red}Error adding sqlfile to the tarball ... Exit without complete!${wipe}"
                exit $rc;
        fi
	echo -e "${green}Done.${wipe}"
	#i will delete the sqlfile
	echo -n "Removing sql file from the file system .. "
	rm -fr $sqlfile
	if [[ $rc != 0 ]]; then
                echo -e "${red}Error removing sql file! .. but anyway I will continute. do not forget to delete the file manually ${wipe}"
                #no need to exit for this error while we can continue creating backup
		#exit $rc;
	else
		echo -e "${green}Done.${wipe}"
        fi
fi




#i will gzip the file
echo -n "Creating gz file $backupfile_name .. "
gzip -9 $full_tar_filename
rc=$?;
if [[ $rc != 0 ]]; then
echo -e "${red}creating gz file from tarball filer faild ... Exit without complete!${wipe}"
exit $rc;
 fi
echo -e "${green}gz file has been created${wipe}"
echo "backup file has been created and saved in $cfg_backup_dest/$backupfile_name"
