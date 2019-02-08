#!/bin/bash

kick="/usr/local/android-studio/bin"

chk=`ps aux | grep -v grep | grep studio.sh`
chk_def='echo $chk | grep defunct'
if [ -n "$chk" ] && [ -z "$chk_def" ]; then
	echo "¡¡Android Studio está corriendo!! Tiene que deternerlo y terminar el proceso"
	exit 1
fi

uid=`id -u`
date=`date`

enlace=`ls -la .android | grep /tmp/.android.$uid | gawk '{print $NF}'`

echo "Espere..."

if [ -d ~/.android ]; then

 	if [ ! -L ~/.android ]; then
      	
 		if [ -d /tmp/.android.$uid ]; then
			mv /tmp/.android.$uid /tmp/.android.$uid.$date
			echo "Creando copia de respaldo de /tmp/.android.<NIA>"
		fi

		mv ~/.android ~/.android.bak
		cp -a /.android.bak/ /tmp/.android.$uid
		ln -s /tmp/.android.$uid/ ~/.android
		echo "Creando enlace de ~/.android a /tmp/.android.<NIA>"

		
	elif [ -L ~/.android ] && [ -z "$enlace" ]; then
	
		enlaceErroneo=`ls -la .android | gawk '{print $NF}'`
		
		rm -rf enlaceErroneo
		rm -rf ~/.android
		

		if [ -d /tmp/.android.$uid ]; then
		
			mv /tmp/.android.$uid /tmp/.android.$uid.$date
			echo "Creando copia de respaldo de /tmp/.android.<NIA>"
      		
		fi


		mkdir /tmp/.android.$uid
		ln -s /tmp/.android.$uid ~/.android
		echo "Enlace erróneo. Creando nueva configuración."
	fi

else
	if [ -d /tmp/.android.$uid ]; then		       
		rm -rf /tmp/.android.$uid
		echo "Borrando versiones antiguas de /tmp/.android.<NIA>"
	else	
		mkdir /tmp/.android.$uid	
		echo "Creando configuración en /tmp/.android.<NIA>"
	fi
	
	ln -s /tmp/.android.$uid ~/.android		
	echo "Configuración enlazada"
fi


echo "Corriendo studio.sh"
$kick/studio.sh
