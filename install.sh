#!/bin/bash
#***********************************************************************
# Zerotruth - interface for Zeroshell Captive Portal
# Version: 4.0
# Copyright (C) 2012-2017 Nello Dalla Costa. All rights reserved.
# License:	GNU/GPL, see COPYING
# This file is part of Zerotruth
# Zerotruth is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# Zerotruth is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#************************************************************************
COLUMNS=$(stty size)
COLUMNS=${COLUMNS##* }
COL=$[ $COLUMNS - 10 ]
WCOL=$[ $COLUMNS - 30 ]
SET_COL="echo -en \\033[${COL}G"
SET_WCOL="echo -en \\033[${WCOL}G"
CURS_UP="echo -en \\033[A"
NORMAL="echo -en \\033[0;39m"
SUCCESS="echo -en \\033[1;32m"
WARNING="echo -en \\033[1;33m"
FAILURE="echo -en \\033[1;31m"
print_error_msg()
{
:
}
evaluate_retval()
{
	error_value=$?

	if [ $error_value = 0 ]
	then
		print_status success
	else
		print_status failure
	fi

	return $error_value
}
print_status()
{
	if [ $# = 0 ]
	then
		echo "Usage: $0 {success|warning|failure}"
		return 1
	fi

	$CURS_UP

	case "$1" in
		success)
			$SET_COL
			echo -n "[  "
			$SUCCESS
			echo -n "OK"
			$NORMAL
			echo "  ]"
			;;
		warning)
			case "$2" in
				running)
					$SET_WCOL
					echo "Already running"
					$CURS_UP
					;;
				not_running)
					$SET_WCOL
					echo "Not running"
					$CURS_UP
					;;
			esac
			$SET_COL
			echo -n "[ "
			$WARNING
			echo -n "ATTN"
			$NORMAL
			echo " ]"
			;;
		failure)
			$SET_COL
			echo -n "["
			$FAILURE
			echo -n "FAILED"
			$NORMAL
			echo "]"
			;;
	esac
}
C_SYSTEM="/Database/var/register/system"
C_LDAPBASE="$(cat $C_SYSTEM/ldap/base)"
C_LDAPROOT="$(cat $C_SYSTEM/ldap/rootpw)"
C_LDAPMANAGER="cn=Manager"
C_CP_DIR="$C_SYSTEM/cp"
C_ACCT_DIR="$C_SYSTEM/acct"
C_CRON_SCRIPTS_DIR="$C_SYSTEM/startup/scripts"
C_REGISTER="/Database/var/register"
C_ZT_DIR="/DB/apache2/cgi-bin/zerotruth"
C_CLASSES_DIR="$C_SYSTEM/acct/classes"
C_CRON_TEMP_DIR="$C_ZT_DIR/tmp/crontab"
C_ZT_BIN_DIR="$C_ZT_DIR/bin"
C_ZT_SCRIPTS_DIR="$C_ZT_DIR/scripts"
C_ZT_CONF_DIR="$C_ZT_DIR/conf"
C_ZT_LOG_DIR="$C_ZT_DIR/log"
C_ZT_LIB_DIR="$C_ZT_DIR/lib"
C_ZT_PROXY_DIR="$C_ZT_DIR/proxy"
C_HTDOCS_DIR="/DB/apache2/htdocs"
C_HTDOCS_ZT_DIR="$C_HTDOCS_DIR/zerotruth"
C_HTDOCS_CONF_DIR="$C_HTDOCS_ZT_DIR/conf"
C_HTDOCS_CSS_DIR="$C_HTDOCS_ZT_DIR/css"
C_HTDOCS_SCRIPTS_DIR="$C_HTDOCS_ZT_DIR/scripts"
C_HTDOCS_TEMPLATE_DIR="$C_HTDOCS_ZT_DIR/template"
C_ZS_SCRIPTS_DIR="/root/kerbynet.cgi/scripts"
C_ZS_TEMPLATE_DIR="/root/kerbynet.cgi/template"
C_ZS_CRON_SCRIPT="$C_ZS_SCRIPTS_DIR/runscript"
BLUEWHITE="\e[37;44m"
BLUE="\e[0;34m"
RED="\e[0;31m"
echo ""
echo -en $BLUE"**********************************************************\n"
echo "*    _________           Welcome                         *"
echo "*   /______  /                                           *"
echo "*         / /             _             _   _            *"
echo "*        / /___ _ __ ___ | |_ _ ___   _| |_| | v.4.0     *"
echo "*       / // _ \ '__/ _ \| __| '_/ | | | __| |__         *"
echo "*      / /|  __/ | | (_) | |_| | | |_| | |_|  _ \        *"
echo "*     / /_ \___|_|  \___/\___|_| \____/\___| | |_| _     *"
echo "*    /______________________________________________/    *"
echo "*          Interface for ZeroShell Captive Portal        *"
echo "*                                                        *"
echo "*          To install ZeroTruth press <ENTER> key        *"
echo -en "**********************************************************\n"
$NORMAL
read install
echo ""
echo -n "Choose your language [ITA/eng]: "
read scelta
if [ "$scelta" == "eng" ];then
	language="english"
	installazione="Installation ZeroTruth"
	avviso1="ZeroShell Captive Portal is not active"
	avviso2="Before you install zeroTruth you have to activate it from ZeroShell"
	avviso3="See you soon."
	mkfolders="Create the Folders"
	fatto="Done!"
	mklinks="Create symbolic links"
	install="Install files "
	riavvioht="Restart the httpd server"
	riavvioldap="Restart Ldap"
	aggiorno="Upgrade"
	aggperm="Update the permissions"
	aggldap="Update LDAP"
	riavviocron="restart crond"
	cosucce="Other little things"
	generalinfo="Information unavailable"
	postreg="Info post registration"
	userblock="Info user blocked"
	activecp="Activate the Captive Portal?"
	deleteoldconf="delete old possible configuration"
	wronghostname="Hostname is not FQDN."
else
	language="italiano"
	installazione="Installazione ZeroTruth"
	avviso1="Non è attivo il Captive Portal di ZeroShell"
	avviso2="Prima di installare ZeroTruth lo devi attivare da ZeroShell"
	avviso3="A presto!"
	mkfolders="Creo le cartelle"
	fatto="Fatto!"
	mklinks="Creo i link simbolici"
	install="Installo i files "
	riavvioht="Riavvio il server httpd"
	riavvioldap="Riavvio Ldap"
	aggiorno="Aggiorno"
	aggperm="Aggiorno i permessi"
	aggldap="Aggiorno LDAP"
	riavviocron="Riavvio crond"
	cosucce="Altre cosucce"
	generalinfo="Informazioni non disponibili"
	postreg="Info post registrazione"
	userblock="Info utente bloccato"
	activecp="Attivo il Captive Portal?"
	deleteoldconf="Elimino eventuali vecchie configurazioni"
	wronghostname="Hostname non FQDN non è permesso da Zerotruth."
fi
echo -en $BLUEWHITE$installazione
$NORMAL

controlhostname="$(echo $HOSTNAME | sed 's/\./ /g' | wc -w | awk '{print $1}')"
if [ "$controlhostname" != "3" ];then
	echo ""
	echo "$wronghostname"
	echo ""
	exit
fi
if [[ -f $C_CP_DIR/Interface && $(cat $C_CP_DIR/Enabled) == "yes" ]];then
	interfacecp=$(cat $C_CP_DIR/Interface | awk '{print $1}')
	controlv=$(echo "$interfacecp" | cut -sd'.' -f2)
	if [ -n "$controlv" ];then
		interface=$(echo "$interfacecp" | cut -d'.' -f1)
		ipcp=$(cat $C_SYSTEM/net/interfaces/$interface/VLAN/$controlv/IP/00/IP)
		ln -f -s $C_SYSTEM/net/interfaces/$interface/VLAN/$controlv/IP/00/IP $C_SYSTEM/cp/Auth/Custom/IP
	else
		ipcp=$(cat $C_SYSTEM/net/interfaces/$interfacecp/IP/00/IP)
		ln -f -s $C_SYSTEM/net/interfaces/$interfacecp/IP/00/IP $C_SYSTEM/cp/Auth/Custom/IP
	fi
else
	echo ""
	echo "$avviso1"
	echo "$avviso2"
	echo ""
	echo "$avviso3"
	echo " "
	exit
fi
echo ""
echo ""
echo "$deleteoldconf"
for confcustom in "IP" "GeneralInfo" "Description" "PostRegistration" "UserBlocked" "RedirectFree" "LoginML" "DomainVisible" "UsersLike" "msg" "CpFree" \
	"Popup" "WalledGarden" "RePass" "ShowMB" "ShowCost" "ShowImgLogin" "Domain" "RegisterSocial" "RegisterAsterisk" "ChargePayPal" \
	"Registered" "SRVWalledGarden" "TypeWalledGarden" "RedUrlWalledGaeden" "IpUrlWalledGarden" "PopupActive" "EnforcePopup" "RePass" "Template";do
	rm -rf $C_SYSTEM/cp/Auth/Custom/$confcustom 2>/dev/null
done
rm -rf $C_SYSTEM/cp/Auth/URLrid* 2>/dev/null
rm -rf $C_SYSTEM/cp/Auth/UseURL 2>/dev/null
print_status success
echo ""
echo  "$mkfolders"
mkdir /DB/apache2
mkdir /DB/apache2/cgi-bin
mkdir /DB/apache2/htdocs
mkdir /DB/apache2/htdocs/conf
mkdir $C_HTDOCS_ZT_DIR
mkdir $C_HTDOCS_ZT_DIR/cgi-bin
mkdir $C_HTDOCS_ZT_DIR/images
print_status success
echo ""
echo "$mklinks"
for slink in "CapPortAS.conf" "CapPortGW.conf" "bin" "build" "cp" "error" "icons" "include" "lib" \
	"logs" "man" "modules";do
	ln -s /usr/local/apache2/$slink /DB/apache2/$slink
done
for file in $( ls -A /usr/local/apache2/htdocs/);do
	ln -s /usr/local/apache2/htdocs/$file /DB/apache2/htdocs/$file
done
for file in $( ls -A /usr/local/apache2/cgi-bin/ );do
	ln -s /usr/local/apache2/cgi-bin/$file  /DB/apache2/cgi-bin/$file
done
print_status success
echo ""
echo "$install"
tar zxvf zerotruth.tar.gz -C / >/dev/null
cp -f /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf-save
ln -s -f $C_HTDOCS_CONF_DIR/httpd.conf  /etc/httpd/conf/httpd.conf
cp -f /etc/httpd/conf/ssl.conf /etc/httpd/conf/ssl.conf-save
ln -s -f $C_HTDOCS_CONF_DIR/ssl.conf /etc/httpd/conf/ssl.conf
cp -f /usr/local/apache2/htdocs/index.html /DB/apache2/htdocs/indexzs.html
cp -f $C_ZS_SCRIPTS_DIR/cp_authorize_client $C_ZS_SCRIPTS_DIR/cp_authorize_client-save
ln -s -f $C_HTDOCS_SCRIPTS_DIR/cp_authorize_client $C_ZS_SCRIPTS_DIR/cp_authorize_client
cp -f $C_ZS_SCRIPTS_DIR/acct_userlimits $C_ZS_SCRIPTS_DIR/acct_userlimits-save
ln -s -f $C_HTDOCS_SCRIPTS_DIR/acct_userlimits $C_ZS_SCRIPTS_DIR/acct_userlimits
cp -f $C_ZS_SCRIPTS_DIR/cp_connect $C_ZS_SCRIPTS_DIR/cp_connect-save
ln -s -f $C_HTDOCS_SCRIPTS_DIR/cp_connect $C_ZS_SCRIPTS_DIR/cp_connect
cp -f $C_ZS_SCRIPTS_DIR/cp_auth_start $C_ZS_SCRIPTS_DIR/cp_auth_start-save
ln -s -f $C_HTDOCS_SCRIPTS_DIR/cp_auth_start $C_ZS_SCRIPTS_DIR/cp_auth_start
cp -f $C_ZS_SCRIPTS_DIR/cp_getaccounting $C_ZS_SCRIPTS_DIR/cp_getaccounting-save
ln -s -f $C_HTDOCS_SCRIPTS_DIR/cp_getaccounting $C_ZS_SCRIPTS_DIR/cp_getaccounting
cp -f $C_ZS_SCRIPTS_DIR/acct_interim_update $C_ZS_SCRIPTS_DIR/acct_interim_update-save
ln -s -f $C_HTDOCS_SCRIPTS_DIR/acct_interim_update $C_ZS_SCRIPTS_DIR/acct_interim_update
cp -f $C_ZS_SCRIPTS_DIR/acct_start $C_ZS_SCRIPTS_DIR/acct_start-save
ln -s -f $C_HTDOCS_SCRIPTS_DIR/acct_start $C_ZS_SCRIPTS_DIR/acct_start
cp -f $C_ZS_SCRIPTS_DIR/cp_createticket $C_ZS_SCRIPTS_DIR/cp_createticket-save
ln -s -f $C_HTDOCS_SCRIPTS_DIR/cp_createticket $C_ZS_SCRIPTS_DIR/cp_createticket
cp -f $C_CP_DIR/Auth/Template/cp_showauth_custom $C_CP_DIR/Auth/Template/cp_showauth_custom-save
ln -s -f  $C_HTDOCS_ZT_DIR/templates/default $C_HTDOCS_TEMPLATE_DIR
ln -s -f $C_HTDOCS_ZT_DIR/templates/default/cgi-bin $C_HTDOCS_ZT_DIR/cgi-bin/template
cp -f $C_ZS_TEMPLATE_DIR/cp_clientctrl $C_ZS_TEMPLATE_DIR/cp_clientctrl-save
ln -s -f $C_HTDOCS_TEMPLATE_DIR/cp_clientctrl $C_ZS_TEMPLATE_DIR/cp_clientctrl
cp -f $C_ZS_TEMPLATE_DIR/cp_clientctrl_renew $C_ZS_TEMPLATE_DIR/cp_clientctrl_renew-save
ln -s -f $C_HTDOCS_TEMPLATE_DIR/cp_clientctrl_renew $C_ZS_TEMPLATE_DIR/cp_clientctrl_renew
cp -f $C_ZS_TEMPLATE_DIR/cp_clientctrl_failed $C_ZS_TEMPLATE_DIR/cp_clientctrl_failed-save
ln -s -f $C_HTDOCS_TEMPLATE_DIR/cp_clientctrl_failed $C_ZS_TEMPLATE_DIR/cp_clientctrl_failed
cp -f $C_ZS_TEMPLATE_DIR/setup_menu $C_ZS_TEMPLATE_DIR/setup_menu-save
ln -s -f $C_HTDOCS_TEMPLATE_DIR/setup_menu $C_ZS_TEMPLATE_DIR/setup_menu
cp -f /etc/openldap/schema/inetorgperson.schema /etc/openldap/schema/inetorgperson.schema-save
ln -s -f $C_HTDOCS_CONF_DIR/inetorgperson.schema  /etc/openldap/schema/inetorgperson.schema
ln -s -f $C_HTDOCS_ZT_DIR/templates/default/images $C_HTDOCS_ZT_DIR/images/template
ln -s -f $C_HTDOCS_ZT_DIR/templates/default/images $C_HTDOCS_DIR/images/template
ln -s -f $C_HTDOCS_ZT_DIR/templates/default/css $C_HTDOCS_ZT_DIR/css/template
echo "custom" > $C_CP_DIR/Auth/Template/Template
echo "default" > $C_CP_DIR/Auth/Custom/Template
ln -f -s $C_HTDOCS_DIR/js $C_HTDOCS_ZT_DIR/js
print_status success
echo ""
echo "$riavvioht"
/etc/init.d/httpd restart
echo ""
echo "$riavvioldap"
/etc/init.d/ldap restart
echo ""
echo "$aggldap"
### update LDAP
$C_ZT_SCRIPTS_DIR/ldapRepair.sh >/dev/null
##########
print_status success
echo ""
echo "$aggiorno LD_PATH"
echo "/DB/apache2/cgi-bin/zerotruth/lib" >> /etc/ld.so.conf
ldconfig 2>/dev/null >/dev/null
print_status success
echo ""
echo "$aggiorno postboot"
echo "/DB/apache2/cgi-bin/zerotruth/scripts/ztpostboot.sh" >> $C_SYSTEM/startup/scripts/postboot/File
echo "yes" > $C_SYSTEM/startup/scripts/postboot/Enabled
print_status success
echo ""
echo "$aggperm "
chmod 4755 /DB/apache2/cgi-bin/zerotruth/bin/zt
chmod 4755 /DB/apache2/cgi-bin/zerotruth/bin/ztx
print_status success
echo ""
echo "$aggiorno Crontab"
if [ -d $C_CRON_SCRIPTS_DIR/ZTcontrolore-Cron ];then
	rm -rf $C_CRON_SCRIPTS_DIR/ZTcontrolore-Cron
fi
if [ ! -d $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron ];then
	mkdir $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron
	mkdir $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron/cron
fi
echo "Cron ZTcontrol" > $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron/Description
echo "yes" > $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron/Enabled
echo "# Bash script: ZTcontrol-Cron" > $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron/File
echo "$C_ZT_BIN_DIR/zt Control" >> $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron/File
chmod 755 $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron/File
echo "5 m" > $C_CRON_SCRIPTS_DIR/ZTcontrol-Cron/cron/Step

if [ ! -d $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron ];then
	mkdir $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron
	mkdir $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/cron
fi
let HOUR=$RANDOM%23
let MINUTE=$RANDOM%59
echo "Cron ZTcontrolupdate" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/Description
echo "yes" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/Enabled
echo "$C_ZT_BIN_DIR/zt ControlUpdate" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/File
chmod 755 $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/File
echo "*" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/cron/DoW
echo "*" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/cron/DoM
echo "$HOUR" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/cron/Hour
echo "$MINUTE" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/cron/Minute
echo "*" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/cron/Month
echo "" > $C_CRON_SCRIPTS_DIR/ZTcontrolupdate-Cron/cron/Step

if [ ! -d $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron ];then
	mkdir $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron
	mkdir $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/cron
fi
echo "Cron ZTunlockclientday" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/Description
echo "yes" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/Enabled
echo "$C_ZT_BIN_DIR/zt UnlockClientDay" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/File
chmod 755 $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/File
echo "*" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/cron/DoW
echo "*" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/cron/DoM
echo "0" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/cron/Hour
echo "1" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/cron/Minute
echo "*" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/cron/Month
echo "" > $C_CRON_SCRIPTS_DIR/ZTunlockclientday-Cron/cron/Step

if [ ! -d $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron ];then
	mkdir $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron
	mkdir $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/cron
fi
echo "Cron ZTunlockclientonth" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/Description
echo "yes" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/Enabled
echo "$C_ZT_BIN_DIR/zt UnlockClientMonth" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/File
chmod 755 $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/File
echo "*" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/cron/DoW
echo "1" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/cron/DoM
echo "0" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/cron/Hour
echo "1" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/cron/Minute
	echo "*" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/cron/Month
	echo "" > $C_CRON_SCRIPTS_DIR/ZTunlockclientmonth-Cron/cron/Step
print_status success
echo ""
echo "$riavviocron"
/etc/init.d/crond restart
echo ""
echo "$cosucce ..."
echo -e "$generalinfo" > $C_CP_DIR/Auth/Custom/GeneralInfo
echo -e "Zerotruth hot spot" > $C_CP_DIR/Auth/Custom/Image/Description
echo -e "$generalinfo" > $C_CP_DIR/Auth/Custom/AccountInfo
echo -e "$postreg" > $C_CP_DIR/Auth/Custom/PostRegistration
echo -e "$userblock" > $C_CP_DIR/Auth/Custom/UserBlocked
echo -e "zerotruth.net" > $C_CP_DIR/Auth/Custom/RedirectFree
#echo -e "yes" > $C_CP_DIR/Auth/Custom/LoginML
ln -f -s $C_ZT_DIR/controlpp.sh  $C_HTDOCS_ZT_DIR/cgi-bin/controlpp.sh
ln -f -s $C_ZT_DIR/qrcontrol.sh  $C_HTDOCS_ZT_DIR/cgi-bin/qrcontrol.sh
ln -f -s $C_ZT_DIR/remotecp.sh  $C_HTDOCS_ZT_DIR/cgi-bin/remotecp.sh
ln -f -s $C_ZT_DIR/unlockasterisk.sh  $C_HTDOCS_ZT_DIR/cgi-bin/unlockasterisk.sh
sed -i "s/^C_LANGUAGE=.*/C_LANGUAGE=\"$language\"/g" $C_ZT_CONF_DIR/zt.config
cp -a  $C_CP_DIR/msg/custom $C_HTDOCS_ZT_DIR/msg/custom 2> /dev/null
cat $C_CP_DIR/msg/Lang > $C_HTDOCS_ZT_DIR/msg/Lang 2> /dev/null
echo "Custom" >  $C_CP_DIR/msg/Lang 2> /dev/null
cp -a $C_ZT_DIR/proxy/languages/havp/$language $C_ZT_DIR/proxy/languages/havp/template
rm -r -f $C_CP_DIR/msg/custom/* 2> /dev/null
echo "yes" > $C_CP_DIR/Auth/Custom/DomainVisible
cp  $C_HTDOCS_ZT_DIR/msg/$language/* $C_CP_DIR/msg/custom/ 2> /dev/null
chmod 777 $C_ZT_DIR/tmp
useradd proxy 2> /dev/null
ln -s $C_HTDOCS_ZT_DIR/msg $C_CP_DIR/Auth/Custom/msg 2>/dev/null
chmod -R 777 $C_HTDOCS_ZT_DIR/images/template/wg
chmod -R 777 $C_HTDOCS_ZT_DIR/images/template/popup
chmod -R 777 $C_HTDOCS_ZT_DIR/images/template/imglogin
chmod -R 777 $C_HTDOCS_ZT_DIR/images/template/fb
echo "no" > $C_CP_DIR/Auth/Custom/CpFree
echo "TEMPLATEPATH $C_HTDOCS_ZT_DIR/havp/template" >> $C_ZS_TEMPLATE_DIR/havp.config
print_status success
echo ""
echo -n "$activecp [NO/yes]: "
read scelta
if [ "$scelta" == "yes" ];then
	ln -s -f $C_HTDOCS_TEMPLATE_DIR/cp_showauth_custom-on $C_CP_DIR/Auth/Template/cp_showauth_custom
	chown root:root $C_HTDOCS_TEMPLATE_DIR/cp_showauth_custom-on
	sed -i "s/^C_ACTIVE_CP.*/C_ACTIVE_CP=\"on\"/g" $C_ZT_CONF_DIR/zt.config
	echo "" > $C_CP_DIR/msg/custom/Registered
else
	ln -s -f $C_HTDOCS_TEMPLATE_DIR/cp_showauth_custom-off $C_CP_DIR/Auth/Template/cp_showauth_custom
fi
DATEUTC="$(date -u | awk '{print $4}' | cut -d':' -f1 | sed 's/^0//g')"
DATECET="$(date  | awk '{print $4}' | cut -d':' -f1 | sed 's/^0//g')"
DIFFSEC="$(echo $(($DATECET-$DATEUTC))*3600 | $C_ZT_DIR/bin/bc)"
echo "" >> $C_ZT_CONF_DIR/zt.config
echo "# DIFFSEC" >> $C_ZT_CONF_DIR/zt.config
echo "C_DIFFGMT=\"$DIFFSEC\"" >> $C_ZT_CONF_DIR/zt.config

print_status success
echo ""

echo "#***********************************************************************"
echo "# Zerotruth - interface for Zeroshell Captive Portal"
echo "# Version: 4.0"
echo "# Copyright (C) 2012-2017 Nello Dalla Costa. All rights reserved."
echo "# License: GNU/GPL, see COPYING"
echo "# "
echo "# Zerotruth is free software: you can redistribute it and/or modify"
echo "# it under the terms of the GNU General Public License as published by"
echo "# the Free Software Foundation, either version 3 of the License, or"
echo "# (at your option) any later version."
echo "# Zerotruth is distributed in the hope that it will be useful,"
echo "# but WITHOUT ANY WARRANTY; without even the implied warranty of"
echo "# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
echo "# GNU General Public License for more details."
echo "#************************************************************************"
echo ""
echo -en $RED "Buon ZeroTruth"
$NORMAL
echo ""
