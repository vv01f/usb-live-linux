#!/bin/bash
#===========================================
#         FILE: fsfw-uni-stick_build.sh
#        USAGE: ./fsfw-uni-stick_build.sh - ( ausführen im live-build-Verzeichnis )
#  DESCRIPTION: erstellen des FSFW-Uni-Stick
#        
#      VERSION: 0.0.1
#      OPTIONS: $1 = DEVICE=/dev/sd... Gerät/USB-Stick der benutzt werden soll
#		     (zu formatierendes Gerät/Device .z.B.: /dev/sdb )
#        NOTES: für - live-build - Debian jessie / Debian stretch - LANG=de_DE.UTF-8
#               
#
#       AUTHOR: Gerd Göhler, gerdg-dd@gmx.de
#      CREATED: 2016-10-21
#     REVISION: 
#       Lizenz: CC BY-NC-SA 3.0 DE - https://creativecommons.org/licenses/by-nc-sa/3.0/de/#
#               https://creativecommons.org/licenses/by-nc-sa/3.0/de/legalcode
#==========================================

# TODO: Skript Installation auf benötigte Pakete testen

# 	sudo grub2 parted dosfstools gzip syslinux-common wget dialog util-linux pandoc qemu live-build live-config-systemd live-boot

# Dialog welche Aufgaben sollen eredigt werden ? - default alle ?
#
#	FSFW_UNI_Stick_*.iso bauen (CD-Image)
#	Doku bauen und verteilen
#	FSFW user config erstellen	
#	USB-Stick erstellen (komplettes Image mit WIN-DATEN und Persistence Partition)
#	Windows Programme copieren ( auf WIN-DATEN Partition )
#
#



# Der eigentliche Skript-Inhalt liegt innerhalb der folgenden Funktion
# deren Ausgabe kann dann gleichzeitig in ein Dateien und nach stdout geleitet werden
main_function() {

# Hinweis bzgl. benötigter superuser-Rechete

if [ "$(id -u)" != "0" ]; then
   echo " "
   echo "Hinweis: Dieses Skript wird derzeit nicht mit root-Rechten ausgeführt."
   echo "Diese werden bei Bedarf (ggf. mehrfach) abgefragt."
   echo " "
   echo " "
   sleep 1
fi

# live-build Umgebung aufräumen
sudo lb clean

# Paketlisten generieren
./auto/paketliste

# extra Pakete holen

# TODO:
#script extra-install_paket.sh 	# Paketlisten nach extra-instell Pakenten durchsuchen und download nach config/packages.chroot/*
../tools/extra-install_paket.sh

# Doku bauen und verteilen

# TODO: 
#script doku_create.sh		# ../html/*  --> ../../FSFW-Uni-Stick/config/includes.chroot/var/www/
../tools/doku_create.sh

# FSFW user config erstellen
# TODO:
#script fsfw-user_config.sh 	# user config aus doc/src_user-config/*  --> config/includes.chroot/home/user/  --> config/includes.chroot/etc/...
# git-versionsnummer / link --> config/includes.chroot/home/user/.version_fsfw-uni-stick
../tools/fsfw-user_config.sh

# live-build config generieren -- optionaler Zwischenschritt um config manuell anzupassen - wird sonst von "lb build" mit erledigt 
# sudo lb config
# sudo chown -R ${USER}:${USER} ./config

# live-build config generieren und FSFW_UNI_Stick_*.iso bauen
sudo lb build

# Benutzerberechtigung ändern 
echo "Benutzerberechtigung ändern "
sudo chown ${USER}:${USER} ./FSFW-Uni-Stick*.iso

# TODO:
# USB-Stick erstellen - Speichergerät partitionieren,formatieren - FSFW_UNI_Stick_*.iso schreiben
# script mit $1 starten oder später abfrage ?? 
# sudo ../tools/FSFW_-_USB-Stick_erstellen.sh $1


# TODO:
# Windows Programme downoad & copieren auf WIN-DATEN Partition
# usb-live-linux/doc/src/windows.md	- anpassen [Programm] (download-path-programm.zip *.exe ..*.etc )
#script win-daten_download.sh
#script win-daten_copy.sh
#

# TODO:
# Distibution / Verteilung Script
# script Uni_Stick_distri.show
#
# pack USBImage (ZIP)
# make Checksums (PGP, MD5, SHA256, SHA512)
# create Torrent with Webseed
# create Magnet Link

}


main_function 2>&1 | tee -a fsfw-build-script.log


