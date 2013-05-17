#!/bin/bash
v1="2.7.8"
test1=$1
test2=$2
# This tool was created by Jeff "Waldo" Thompson and all bugs should be reported to 
# waldo@warezwaldo.us  -- or -- waldo.thompson@rackspace.com 
# Vdetect is designed to aide in indentifying the currently installed version of software.
# This tool will currently identify the following types of CMS software:
# 1) Wordpress
# 2) Joomla
# 3) Drupal
# 4) Magento
# 5) phpBB
# 6) Zen Cart
# 7) openCart
# 8) vBulletin
# 9) Moodle
#
# Development of this tool is an ongoing process and I will be adding support for Magento, and
# other popular websites systems like openCart, Zencart, and Moodle
#
# please report any bugs to waldo@warezwaldo.us
txtrst=$(tput sgr0)
txtbld=$(tput bold)
txtred=$(tput setaf 1) # Red
txtgrn=$(tput setaf 2) # Green
txtylw=$(tput setaf 3) # Yellow
txtblu=$(tput setaf 4) # Blue
txtpur=$(tput setaf 5) # Purple
txtcyn=$(tput setaf 6) # Cyan
txtwht=$(tput setaf 7) # White

#
function myversion()
{
myver=`curl -q http://scripts.rs-scripts.com/vdetect 2> /dev/null |sed '1,1d'`
}
myversion
#
function print_outdate()
{
clear
echo ""
echo ""
echo "You are running an older version of vdetect.sh.  You should update"
echo "to ensure that you get the most out of this script. There may have"
echo "been bug fixes or feature additions that may help you."
echo ""
echo "The version being run: $v1"
echo "Current version is: $myver"
echo ""
echo "Do you want me to auto-update or not??  (y/n)"
read autoupdate
if [ $autoupdate == 'y' ]; then 
rm -rf ./vdetect.sh
wget http://scripts.rs-scripts.com/vdetect.sh 2> /dev/null
echo ""
echo ""
exec sh vdetect.sh $test1 $test2
echo "Please re-run vdetect.sh -- you should be able to use the up arrow"
exit 102
fi
echo "Sorry you have an outdated version it will not run"
do_help
}
#
function version_check()
{
echo "Updating Wordpress Current Version...."
curl -q http://wordpress.org/download/release-archive/ 2&> ./ver_finder
file123=./ver_finder
current=(`grep "latest" $file123|grep -o "[0-9]\.[0-9]"`)
ver=`grep -o "wordpress-$current.[0-9]" $file123 |tail -1|awk 'BEGIN {FS="-"}; {print$2}'`
rm -rf ./ver_finder
}
#version_check
function version_check1()
{
echo "Updating phpBB Current Version...."
ver22=`curl -k https://www.phpbb.com/ 2> /dev/null|grep version|grep Download|awk 'BEGIN {FS=">"}; {print$4}'|awk 'BEGIN {FS="<"}; {print$1}'`
}
#version_check1
function version_check2()
{
echo "Updating Joomla Current Version...."
ver23=`curl http://www.joomla.org/download.html 2> /dev/null |grep newest|awk 'BEGIN {FS="<p>"}; {print$2}'|egrep -o "[0-9]\.[0-9]"`
}
#version_check2
function version_check3()
{
echo "Updating Drupal Current Version...."
ver24=`curl http://drupal.org/project/drupal 2> /dev/null|grep -A2 "views.row.first"|grep "-release-notes"|awk 'BEGIN {FS=">"}; {print$2}'|awk 'BEGIN {FS="<"}; {print$1}'`
}
#version_check3
function version_check4()
{
echo "Updating Magento Current Version...."
ver25=`curl http://www.magentocommerce.com/download 2> /dev/null |grep -A3 "Full Release"|awk 'BEGIN {FS="%"}; {print$5}'|cut -c3-`
}
#version_check4
function version_check5()
{
echo "Updating Zen Cart Current Version...."
ver26=`curl http://sourceforge.net/projects/zencart/files/ 2> /dev/null |grep "CURRENT"|grep "Zen Cart"|grep '</a>'|awk 'BEGIN {FS="<"}; {print$1}'`
ver27=`echo "${ver26// /%20}"|cut -c73-`
current=`curl http://sourceforge.net/projects/zencart/files/$ver27/ 2> /dev/null|grep -i "zen cart"|grep "full"|awk 'BEGIN {FS="="}; {print$4}'|awk 'BEGIN {FS="/"}; {print$3}'|awk 'BEGIN {FS=":"}; {print$1}'|grep zip|awk 'BEGIN {FS="-"}; {print$3}'|cut -c2-`
}
#version_check5
function version_check6()
{
echo "Updating Moodle Current Version...."
ver28=`curl http://download.moodle.org/ 2> /dev/null|grep -i "Current Stable"|awk 'BEGIN {FS="</a>"}; {print$5}'|grep -o "actual [0-9]\.[0-9]\.[0-9]"|awk '{print$2}'`
}
#version_check6
#
#
function do_pause()
{
echo "${txtylw}Please Press Enter to continue${txtrst}"
read doppler
}

function phpBB_scan_mini()
{
version_check1
gonogo4=`find $start_dir -type f -name "mcp.php" 2> /dev/null |wc -l`
gonogo5=`find $start_dir -type f -name "ucp.php" 2> /dev/null |wc -l`
if [ $gonogo4 == "0" ]; then
        if [ $gonogo5 == "0" ]; then
        gonogo9='0'
        fi
        if [ $gonogo9 == "0" ]; then
        echo "${txtpur}Sorry No phpBB websites found moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"
        fi

else
        echo "${txtpur}Gathering ALL installed phpBB Websites and Version info..."
        for i in `find $start_dir -type f -name "config.php" 2> /dev/null`
        do
        crup=`echo $i|sed -n 's/.\(10\)$//'`
	if [ "$crup" != "$start_dir" ]; then
	echo "bad config file... $i" > /dev/null
	else
	dbuser=`grep '$dbuser' $i|awk 'BEGIN {FS="="}; {print$2}'|cut -c3-|sed 's/.\{2\}$//'`
        dbpasswd=`grep '$dbpasswd' $i|awk 'BEGIN {FS="="}; {print$2}'|cut -c3-|sed 's/.\{2\}$//'`
        dbname=`grep '$dbname' $i|awk 'BEGIN {FS="="}; {print$2}'|cut -c3-|sed 's/.\{2\}$//'`
        table=$dbname\_config
	ver_12=`mysql -e "use $dbname;SELECT config_value FROM $table WHERE config_name = 'version';"|egrep "[0-9]{1,3}\."`
	echo "${txtywl}phpBB Config file:${txtrst} ${txtcyn}$i${txtrst} "
        if [ -z $ver_12 ]; then
		ver_12=0.0.0
	fi
	if [ $ver_12 != $ver22 ]; then
        echo "${txtylw}Version installed:${txtrst} ${txtred}$ver_12 --- Out of Date Current = $ver22${txtrst}"
        else
        echo "${txtylw}Version installed:${txtrst} ${txtgrn}$ver_12 --- Up to Date ${txtrst}"
        fi
echo "#####################################################################"
	fi        
	done
echo "${txtylw}#####################################################################${txtrst}"

fi
}

function drupal_scan_mini()
{
version_check3
gonogo3=`find $start_dir -type f -name "MAINTAINERS.txt" 2> /dev/null |wc -l`
if [ $gonogo3 == "0" ]; then
echo "${txtpur}Sorry No Drupal websites found moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"

else

dir7=`pwd`
echo "${txtpur}Gathering ALL Instlled Drupal Websites and Version info...${txtrst}";
for i in `find $start_dir -type f -name "MAINTAINERS.txt" 2> /dev/null`
        do
        dir8=`echo $i|sed 's/.\{16\}$//'`
        ver3=`head -1 "$dir8/CHANGELOG.txt"|awk '{print$2}'`
        if [ -z $ver3 ]; then
                ver3=`head -2 "$dir8/CHANGELOG.txt"|tail -1|awk '{print$2}'`
                if [ -z $ver3 ]; then
                        ver3=`head -3 "$dir8/CHANGELOG.txt"|tail -1|awk '{print$2}'`
                        if [ $ver3 != $ver24 ]; then
                        echo "${txtcyn}$dir8${txtrst} : ${txtred}$ver3 --- Out of Date Current = $ver24${txtrst}"
                        else
                        echo "${txtcyn}$dir8${txtrst} : ${txtgrn}$ver3 --- Up to Date${txtrst}"
                        fi
                else
                        if [ $ver3 != $ver24 ]; then
                        echo "${txtcyn}$dir8${txtrst} : ${txtred}$ver3 --- Out of Date Current = $ver24${txtrst}"
                        else
                        echo "${txtcyn}$dir8${txtrst} : ${txtgrn}$ver3 --- Up to Date${txtrst}"
                        fi
                fi
        else
                if [ $ver3 != $ver24 ]; then
                echo "${txtcyn}$dir8${txtrst} : ${txtred}$ver3 --- Out of Date Current = $ver24${txtrst}"
                else
                echo "${txtcyn}$dir8${txtrst} : ${txtgrn}$ver3 --- Up to Date${txtrst}"
                fi

        fi


        done
echo "#####################################################################"

fi

}

function joomla_scan_mini()
{
johnny=0
version_check2
echo "${txtylw}Scanning for Joomla files...${txtrst}"
gonogo1=`find $start_dir -type f -name "configuration.php" 2> /dev/null |wc -l`
inst=`find $start_dir -type d -name "installation" 2> /dev/null |wc -l`
if [ $inst >= "1" ]; then
echo "${txtpur}Sorry I see a Joomla installation folder moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"
else
if [ $gonogo1 == "0" ]; then
echo "${txtpur}Sorry No Joomla websites found moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"

else
#
echo "${txtpur}Gathering All installed Joomla Websites and Version info...${txtrst}"
for i in `find $start_dir -type f -name "configuration.php" 2> /dev/null `
do
dir4=`echo $i|sed 's/.\{18\}$//'`
dir909=`echo $i|grep admin|wc -l`
if [ $dir909 == "0" ]; then
dir5=`grep -Rl '$RELEASE' $dir4`
ver1=`grep '$RELEASE' $dir5|awk 'BEGIN {FS="="}; {print$2}'|cut -c3- |sed 's/.\{2\}$//'`
if [ $ver1 != $ver23 ]; then
echo "${txtcyn}$i${txtrst} : ${txtred}$ver1 --- Out of Date Current = $ver23 ${txtrst}"
johnny=1
else
echo "${txtcyn}$i${txtrst} : ${txtgrn}$ver1 --- Up to Date${txtrst}"
johnny=1
fi
echo "#####################################################################"



fi

done
if [ $johnny == "0" ]; then
echo "${txtylw}#####################################################################${txtrst}"
fi

fi

fi

}

function moodle_scan_mini()
{
version_check6
dire=`find $start_dir -type f -name "TRADEMARK.txt" 2> /dev/null`
dire1=`echo $dire|sed 's/.\{13\}$//'`
cd $dire1 2> /dev/null
if [ -d "cohort" ]; then
	gonogo=1
else
	gonogo=0
fi

if [ $gonogo == "0" ]; then
	echo "${txtpur}Sorry no Moodle websites found moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"
else
echo "${txtpur}Gathering ALL installed Moodle Websites and Version info...${txtrst}"
for i in `find $start_dir -type f -name "TRADEMARK.txt"`
do
dire2=`echo $i|sed 's/.\{13\}$//'`
ver_2323=`grep '$release' $dire2/version.php|awk '{print$3}'|cut -c2-`
if [ $ver_2323 == $ver28 ]; then
echo "${txtcyn}$dire2${txtrst} ${txtgrn} $ver_2323 : Up to Date${txtrst}"
else
echo "${txtcyn}$dire2${txtrst} ${txtred} $ver_2323 : Out of Date Current = $ver28${txtrst}"
fi
echo "#####################################################################"

done
fi
}

function vbull_scan_mini()
{
dir121=`find $start_dir -type f -name "config.php" 2> /dev/null`
dir1212=`echo $dir121|awk 'BEGIN {FS=" "}; {print$1}'|sed 's/.\{32\}$//'`
cd $dir1212
if [ -d upload/core/includes/ ]; then
gonogo=1
else
gonogo=0
fi

if [ $gonogo == "0" ]; then
echo "${txtpur}Sorry no vBulletin websites found moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"
else
echo "${txtpur}Gathering All installed vBulletin Website info...${txtrst}"
for i in `find $start_dir -type f -name "config.php" 2> /dev/null`
do
dir212=`echo $i|awk 'BEGIN {FS=" "}; {print$1}'|sed 's/.\{32\}$//'`
echo "${txtcyn}$dir212${txtrst}"
echo "#####################################################################"
done
fi
}

function open_scan_mini()
{
shit2121=`find $start_dir -type f -name "pagination.php" 2> /dev/null`
shi2121=`echo $shit2121|sed 's/.\{29\}$//'`
cd $shi2121 2> /dev/null
if [ -d system/library ]; then
gonogo=1
else
gonogo=0
fi

if [ $gonogo == "0" ]; then
echo "${txtpur}Sorry no openCart websites found moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"
else
echo "${txtpur}Gathering ALL installed openCart Websites info...${txtrst}"
for i in `find $start_dir -type f -name "pagination.php" 2> /dev/null`
do
#  find version number -- not going to happen until 1.4 and higher
echo "${txtcyn}$shi2121${txtrst}"
echo "#####################################################################"
done
fi
}

function magento_scan_mini()
{
version_check4
gonogo=`find $start_dir -type f -name "Mage.php" 2> /dev/null |wc -l`
if [ $gonogo == "0" ]; then
	echo "${txtpur}Sorry no Magento websites found moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"
else
dir=`pwd`
echo "${txtpur}Gathering All installed Magento Websites and Version info...${txtrst}"
for i in `find $start_dir -type f -name "Mage.php" 2> /dev/null`
do
#dir9=`echo $i|sed 's/.\{8\}$//'`
mag_ver=`php -r "require '$i'; echo Mage::getVersion(); "`
if [ $mag_ver == $ver25 ]; then
echo "${txtcyn}$i${txtrst} : ${txtgrn}$mag_ver --- Up to Date${txtrst} "
else
echo "${txtcyn}$i${txtrst} : ${txtred}$mag_ver --- Out of Date Current = $ver25 ${txtrst} "
echo ""
fi
echo "#####################################################################"

done

fi
}

function zencart_scan_mini()
{
version_check5
gonogo30=`find $start_dir -type f -name "0.about_zen_cart.html" 2> /dev/null |wc -l`
if [ $gonogo30 == "0" ]; then
        echo "${txtpur}Sorry no Zen Cart websites found, moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"
else
echo "${txtpur}Gathering All installed Zen Cart Websites and Version info....${txtrst}"
for i in `find $start_dir -type f -name "0.about_zen_cart.html" 2> /dev/null`
do
dir99=`echo $i|sed 's/.\{26\}$//'`
dir98="$dir99/includes"
majver=`grep "PROJECT_VERSION_MAJOR" $dir98/version.php|awk 'BEGIN {FS=","}; {print$2}'|cut -c3`
minver=`grep "PROJECT_VERSION_MINOR" $dir98/version.php|awk 'BEGIN {FS=","}; {print$2}'|sed 's/.\{3\}$//'|cut -c3-`
ver121=$majver.$minver
if [ "$ver121" != "$current" ]; then
echo "$current"
echo "${txtcyn}$dir99${txtrst} : ${txtred}$ver121 --- Out of Date Current = $current ${txtrst}"
else
echo "${txtcyn}$dir99${txtrst} : ${txtgrn}$ver121 --- Up to Date${txtrst}"
fi
echo "#####################################################################"

done
fi
}

function wordpress_scan_mini()
{
version_check
gonogo=`find $start_dir -type f -name "wp-config.php" 2> /dev/null |wc -l`
if [ $gonogo == "0" ]; then
echo "${txtpur}Sorry No Wordpress websites found moving on....${txtrst}"
echo "${txtylw}#####################################################################${txtrst}"

else
dir=`pwd`;
echo "${txtpur}Gathering All installed Wordpress Websites and Version info...${txtrst}";
for i in `find $start_dir -type f -name "wp-config.php" 2> /dev/null`
do 
dir1=`echo $i|sed 's/.\{14\}$//'`
dir2=`echo "$dir1/wp-includes/version.php"`
ver123=`grep "wp_version =" $dir2|awk 'BEGIN {FS="="}; {print$2}'|cut -c3- |sed 's/.\{2\}$//'`

if [ $ver123 != $ver ]; then
	echo "${txtred}$ver123${txtrst} : ${txtred}Out of Date${txtrst}"
	echo "Config file:${txtylw} $i${txtrst}"
echo "#####################################################################"
	echo ""
else
	echo "${txtgrn}$ver123${txtrst} : ${txtgrn}Up to Date${txtrst}"
	echo "Config File:${txtylw} $i${txtrst}"
echo "#####################################################################"
	echo ""
fi

done

fi

}

function do_help()
{
echo "############################################################"
echo "##      -- Welcome to the VDetect Script Help Page --     ##"
echo "##                                                        ##"
echo "## The following are the available command line flages:   ##"
echo "##                                                        ##"
echo "##  -s \"directory to scan\"  --- specify dir to scan       ##"
echo "##  -w \"directory to scan\"  --- Wordpress Scan            ##"
echo "##  -d \"directory to scan\"  --- Drupal Scan               ##"
echo "##  -b \"directory to scan\"  --- phpBB Scan                ##"
echo "##  -j \"directory to scan\"  --- Joomla Scan               ##"
echo "##  -l \"directory to scan\"  --- Moodle Scan               ##"
echo "##  -m \"directory to scan\"  --- Magento Scan              ##"
echo "##  -o \"directory to scan\"  --- openCart Scan             ##"
echo "##  -v \"directory to scan\"  --- vBulletin Scan            ##"
echo "##  -z \"directory to scan\"  --- Zen Cart Scan             ##"
echo "##  -p  --- Plesk Scan                                    ##"
echo "##  -c  --- Change Log                                    ##"
echo "##                                                        ##"
echo "############################################################"
exit 99

}

function do_usage()
{
clear
echo ""
echo ""
echo ""
echo "You have entered an illegal option: Error (1)"
echo "Please use the following flag for help and script usage:"
echo "./vdetect.sh -h "
echo ""
echo ""
echo ""
exit 98
}


function do_change()
{
clear
echo "This is the Change Log for vdetect.sh"
echo "This script is copyrighted 2011-2013 by Jeff \"Waldo\" Thompson"
echo "and WarezWaldo Services.  This script is provided AS IS and is"
echo "in no way promised or guaranteed to work on every Linux Computer"
echo "please report any bugs to waldo@warezwaldo.us"
echo "${txtred}"
echo "2.7.8 -- removed Site URL printout from Wordpress scan"
echo "2.7.7 -- updated Joomla scan function to help correct a bug when installation folders are found"
echo "2.7.6 -- modified ALL scanner functions text"
echo "2.7.1-2.7.5 --fixing bugs with Joomla scan function"
echo "2.7.0 -- modified the Auto-Updater text Changed for Logan (he's to literral)"
echo "2.6.9 -- modified the Joomal scan text"
echo "2.6.8 -- fixed bug in Wordpress scan function with URL reporting"
echo "2.6.7 -- restructured scanning process for specified and plesk scans"
echo "2.6.6 -- fixed auto-update self-starting"
echo "2.6.5 -- updated Change Log functionality"
echo "2.6.4 -- updated output text for all scan functions"
echo "2.6.3 -- corrected Magento Live Version check output text"
echo "2.6.2 -- modified all Live version checks output text"
echo "2.6.1 -- corrected bug im Moodle scan function"
echo "2.6.0 -- corrected bug in Drupal scan function"
echo "2.5.9 -- corrected bug in Joomal scan function"
echo "2.5.8 -- added version checking to Moodle scan function  ---  -+L"
echo "2.5.7 -- corrected bug with phpBB scan function"
echo "2.5.6 -- added Moodle Live Version Checking function  ---  ++L"
echo "2.5.5 -- added Moodle website detection  ---  ++D"
echo "2.5.4 -- updated all website scan functions output text  ---  -+"
echo "2.5.3 -- added vBulletin website detection  ---  ++D"
echo "2.5.2 -- corrected bug with Zen Cart Live version check"
echo "2.5.1 -- changed autoupdate check function position"
echo "2.5.0 -- corrected bug with autoupdating function"
echo "${txtred}2.4.9 -- corrected bug in phpBB check"
echo "2.4.8 -- added Zen Cart Live Version checking  ---  ++L"
echo "2.4.7 -- corrected bug in phpBB live version check  ---  -+"
echo "2.4.6 -- added autoupdating to this script --- ++AU"
echo "2.4.5 -- added openCart website detection  ---  ++D"
echo "2.4.4 -- added -c flag for interal Change Log  --- -+"
echo "2.4.3 -- added Magento Live Version checking  ---  ++L"
echo "2.4.2 -- corrected 2 typos in printed text"
echo "2.4.1 -- add Zen Cart website detection  ---  ++D"
echo "2.4.0 -- corrected bug with Magento check"
echo "2.3.9 -- corrected bug with Joomla check"
echo "2.3.8 -- added phpBB live version check  ---  ++L"
echo "2.3.7 -- added phpBB website detection  ---  ++D"
echo "2.3.6 -- added drupal live version check  ---  ++L"
echo "2.3.5 -- corrected bug with Wordpress Live check"
echo "2.3.4 -- added druppal website detection  ---  ++D"
echo "2.3.3 -- added Joomla live version check  ---  ++L"
echo "2.3.2 -- corrected typo in printed text"
echo "2.3.1 -- modified the Joomla detection function  ---  -+"
echo "2.3.0 -- modified the Wordpress detection function  ---  -+"
echo "${txtred}2.2.9 -- modified the Magento detection function  ---  -+"
echo "2.2.8 -- added Magento website detection  ---  ++D"
echo "2.1.2 - 2.2.7 -- corrected bugs in all detection functions with version number reporting"
echo "2.1.1 -- added Wordpress Live version checking  ---  ++L"
echo "1.0.1 - 2.1.0 -- added functionality and colorized the text output"
echo "${txtrst}"

}


clear
echo "${txtylw}##################################################"
echo "##                   VDETECT                    ##"
echo "##           Website Version Finder             ##"
echo "##                 version: $v1               ##"
echo "##                                              ##"
echo "##  This tool detects the following websites:   ##"
echo "##  Wordpress, Joomla, Drupal, Magento, phpBB,  ##"
echo "##   ZenCart, openCart, vBulletin, Moodle       ##"
echo "##                                              ##"
echo "##         Live Version Checking for:           ##"
echo "##  Wordpress, Joomla, Drupal, Magento, phpBB,  ##"
echo "##               Zen Cart, Moodle               ##"
echo "##                                              ##"
echo "## This tool was written by Waldo and provided  ##"
echo "##     as is.... however all bugs should be     ##"
echo "##      be reported to waldo@warezwaldo.us      ##"
#echo "##        or waldo.thompson@rackspace.com       ##"
echo "##                                              ##"
echo "##################################################${txtrst}"


while getopts ":s:w:j:m:z:v:l:d:b:o:phc" OPTION; do
case $OPTION in

b)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "phpBB start dir: $OPTARG"
cd $start_dir
phpBB_scan_mini
exit 45
fi
;;

d)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "Drupal start dir: $OPTARG"
cd $start_dir
drupal_scan_mini
exit 46
fi
;;

h)
do_help
;;

j)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "Joomla start dir: $OPTARG"
cd $start_dir
joomla_scan_mini
exit 47
fi
;;

l)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "Moodle start dir: $OPTARG"
cd $start_dir
moodle_scan_mini
exit 53
fi
;;

m)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "Magento start dir: $OPTARG"
cd $start_dir
magento_scan_mini
exit 48
fi
;;

s)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "Starting scan from the following directory: $OPTARG"
cd $OPTARG
wordpress_scan_mini
joomla_scan_mini
drupal_scan_mini
magento_scan_mini
phpBB_scan_mini
zencart_scan_mini
moodle_scan_mini
open_scan_mini
vbull_scan_mini
exit 99
fi
;;

c)
do_change
exit 101
;;

p)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="/var/www/vhosts/"
echo "You have provided the p flag which indicates this is a Plesk Server.  The scan will be run from /var/www/vhosts "
cd $start_dir 
wordpress_scan_mini
joomla_scan_mini
drupal_scan_mini
magento_scan_mini
phpBB_scan_mini
zencart_scan_mini
moodle_scan_mini
open_scan_mini
vbull_scan_mini
exit 100
fi
;;

o)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "openCart start dir: $OPTARG"
cd $start_dir
open_scan_mini
exit 51
fi
;;

w)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "Wordpress start dir: $OPTARG"
cd $start_dir
wordpress_scan_mini
exit 49
fi
;;

v)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "Wordpress start dir: $OPTARG"
cd $start_dir
vbull_scan_mini
exit 52
fi
;;

z)
if [ $v1 != $myver ]; then
clear
print_outdate
else
start_dir="$OPTARG"
echo "Zen Cart start dir: $OPTARG"
cd $start_dir
zencart_scan_mini
exit 50
fi
;;

*)
do_usage
;;

esac
done
exit 42
