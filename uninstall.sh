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
SYSTEM="/Database/var/register/system"
DIRCONF="/DB/apache2/htdocs/zerotruth/conf"
LANGUAGE=$(cat /DB/apache2/cgi-bin/zerotruth/conf/zt.config | grep C_LANGUAGE | cut -d'=' -f2 | sed '/\"/s///g')
if [ "$LANGUAGE" == "italiano" ];then
	AVV="RIMOZIONE ZEROTRUTH"
	AVV1="Lo script disinstalla zerotruth e tutte le sue componenti"
	AVV2="lasciando gli utenti creati"
	AVV3="Per continare digita"
	AVV4="Ci hai ripensato. Esco."
	AVV5="Rimuovo le cartelle e i files di Zerotruth"
	AVV6="Rimuovo le programmazioni"
	AVV7="Rimuovo il postboot?"
	AVV8="Riavvio il server httpd"
	AVV9="Riavvio crond"
	AVV10="Aggiorno LD_PATH"
	AVV11="Disinstallazione Zerotruth completata"
	AVV12="Arrivederci. Spero!"
	FATTO="Fatto!"
	AVV13="Riavvio il server ldap"
else
	AVV="REMOVAL ZEROTRUTH"
	AVV1="The script deletes zerotruth and all its components"
	AVV2="but does not delete users."
	AVV3="To continue typing"
	AVV4="You have changed idea. I go out."
	AVV5="Delete folders and files of Zerotruth"
	AVV6="Remove the programming"
	AVV7="Remove postboot"
	AVV8="Restart the httpd server"
	AVV9="Restart crond"
	AVV10="Update LD_PATH"
	AVV11="Uninstalling zerotruth completed"
	AVV12="Goodbye. I hope!"
	AVV13="Restart the ldap server"
	FATTO="Done!"
fi

echo ""
echo "$AVV"
echo ""
echo "$AVV1"
echo "$AVV2"
echo ""
echo -n "$AVV3 'yes': "
read scelta
if [ "$scelta" != "yes" ];then
	echo ""
	echo "$AVV4"
	echo ""
	exit
fi
echo "$AVV5"
rm -r -f $SYSTEM/cp/msg/custom/* 2> /dev/null
cp  /DB/apache2/htdocs/zerotruth/msg/custom/* $SYSTEM/cp/msg/custom/ 2> /dev/null
cat  /DB/apache2/htdocs/zerotruth/msg/Lang > $SYSTEM/cp/msg/Lang 2> /dev/null
if [ -L /etc/httpd/conf/httpd.conf ];then
	rm -f /etc/httpd/conf/httpd.conf
	mv -f /etc/httpd/conf/httpd.conf-save /etc/httpd/conf/httpd.conf 2> /dev/null
fi
if [ -L /etc/httpd/conf/ssl.conf ];then
	rm -f /etc/httpd/conf/ssl.conf
	mv -f /etc/httpd/conf/ssl.conf-save /etc/httpd/conf/ssl.conf 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/cp_authorize_client ];then
	rm -f /root/kerbynet.cgi/scripts/cp_authorize_client
	mv -f /root/kerbynet.cgi/scripts/cp_authorize_client-save /root/kerbynet.cgi/scripts/cp_authorize_client 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/cp_createticket ];then
	rm -f /root/kerbynet.cgi/scripts/cp_createticket
	mv -f /root/kerbynet.cgi/scripts/cp_createticket-save /root/kerbynet.cgi/scripts/cp_createticket 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/acct_userlimits ];then
	rm -f /root/kerbynet.cgi/scripts/acct_userlimits
	mv -f /root/kerbynet.cgi/scripts/acct_userlimits-save /root/kerbynet.cgi/scripts/acct_userlimits 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/cp_connect ];then
	rm -f /root/kerbynet.cgi/scripts/cp_connect
	mv -f /root/kerbynet.cgi/scripts/cp_connect-save /root/kerbynet.cgi/scripts/cp_connect 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/cp_auth_start ];then
	rm -f /root/kerbynet.cgi/scripts/cp_auth_start
	mv -f /root/kerbynet.cgi/scripts/cp_auth_start-save /root/kerbynet.cgi/scripts/cp_auth_start 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/cp_getaccounting ];then
	rm -f /root/kerbynet.cgi/scripts/cp_getaccounting
	mv -f /root/kerbynet.cgi/scripts/cp_getaccounting-save /root/kerbynet.cgi/scripts/cp_getaccounting 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/acct_interim_update ];then
	rm -f /root/kerbynet.cgi/scripts/acct_interim_update
	mv -f /root/kerbynet.cgi/scripts/acct_interim_update-save /root/kerbynet.cgi/scripts/acct_interim_update 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/acct_start ];then
	rm -f /root/kerbynet.cgi/scripts/acct_start
	mv -f /root/kerbynet.cgi/scripts/acct_start-save /root/kerbynet.cgi/scripts/acct_start 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/scripts/proxy_start ];then
	rm -f /root/kerbynet.cgi/scripts/proxy_start
	mv -f /root/kerbynet.cgi/scripts/proxy_start-save /root/kerbynet.cgi/scripts/proxy_start 2> /dev/null
fi
if [ -L /etc/openldap/schema/inetorgperson.schema ];then
	rm -f /etc/openldap/schema/inetorgperson.schema
	mv -f /etc/openldap/schema/inetorgperson.schema-save /etc/openldap/schema/inetorgperson.schema 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/template/cp_clientctrl ];then
	rm -f /root/kerbynet.cgi/template/cp_clientctrl
	mv /root/kerbynet.cgi/template/cp_clientctrl-save /root/kerbynet.cgi/template/cp_clientctrl 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/template/cp_clientctrl_renew ];then
	rm -f /root/kerbynet.cgi/template/cp_clientctrl_renew
	mv /root/kerbynet.cgi/template/cp_clientctrl_renew-save /root/kerbynet.cgi/template/cp_clientctrl_renew 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/template/cp_clientctrl_failed ];then
	rm -f /root/kerbynet.cgi/template/cp_clientctrl_failed
	mv /root/kerbynet.cgi/template/cp_clientctrl_failed-save /root/kerbynet.cgi/template/cp_clientctrl_failed 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/template/setup_menu ];then
	rm -f /root/kerbynet.cgi/template/setup_menu
	mv /root/kerbynet.cgi/template/setup_menu-save /root/kerbynet.cgi/template/setup_menu 2> /dev/null
fi
if [ -L /root/kerbynet.cgi/template/cp_authorize ];then
	rm -f /root/kerbynet.cgi/template/cp_authorize
	mv /root/kerbynet.cgi/template/cp_authorize-save  /root/kerbynet.cgi/template/cp_authorize 2> /dev/null
fi
rm -r -f /DB/apache2 2> /dev/null
mv $SYSTEM/cp/Auth/Template/cp_showauth_custom-save $SYSTEM/cp/Auth/Template/cp_showauth_custom 2> /dev/null
rm -r -f /DB/apache2 2> /dev/null
for confcustom in "IP" "GeneralInfo" "Description" "PostRegistration" "UserBlocked" "RedirectFree" "LoginML" "DomainVisible" "UsersLike" "msg" "CpFree" \
	"Popup" "WalledGarden" "RePass" "ShowMB" "ShowCost" "ShowImgLogin" "Domain" "RegisterSocial" "RegisterAsterisk" "ChargePayPal" \
	"Registered" "SRVWalledGarden" "TypeWalledGarden" "RedUrlWalledGaeden" "IpUrlWalledGarden" "PopupActive" "EnforcePopup" "RePass" "Template";do
	rm -rf $C_SYSTEM/cp/Auth/Custom/$confcustom 2>/dev/null
done
rm -rf $C_SYSTEM/cp/Auth/URLrid* 2>/dev/null
rm -rf $C_SYSTEM/cp/Auth/UseURL 2>/dev/null
print_status success
echo ""
echo -n "$AVV6 ? [YES/no]: "
read scelta1
if [[ "$scelta1" == "YES" || "$scelta1" == "" ]];then
	echo "$AVV6"
	rm -rf $SYSTEM/startup/scripts/ZT* 2> /dev/null
	print_status success
fi
echo ""
echo "$AVV7"
sed  -i '/ztpostboot/d' $SYSTEM/startup/scripts/postboot/File
print_status success
echo ""
echo "$AVV8"
/etc/init.d/httpd restart
echo ""
echo "$AVV13"
/etc/init.d/ldap restart
echo ""
echo "$AVV9"
/etc/init.d/crond restart
echo ""
echo "$AVV10"
sed -i '/zerotruth/d' /etc/ld.so.conf
ldconfig 2>/dev/null >/dev/null
print_status success
echo ""
echo "$AVV11"
echo ""
echo "$AVV12"
echo ""
