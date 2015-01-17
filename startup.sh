#!/bin/bash

echo Creating user ${X11_USER} when needed
if ! id ${X11_USER}
then
	echo Add the user ${X11_USER}
	adduser --gecos "" --shell /bin/bash --disabled-login --disabled-password ${X11_USER}
	adduser ${X11_USER} sudo

	echo Fixing access rights
	mkdir -p /home/${X11_USER}
	chown -R ${X11_USER} /home/${X11_USER}
	chmod -R u=rwX,go=rX /home/${X11_USER}

	echo Copy the config files into the ${X11_USER} directory
	sudo -u ${X11_USER} cp -uvR /etc/skel/* /etc/skel/.[a-zA-Z0-9]* /home/${X11_USER}/
	sudo -u ${X11_USER} cp -uvR /x11-src/config/* /x11-src/config/.[a-zA-Z0-9]* /home/${X11_USER}/
	ls -l /home/${X11_USER}
fi


echo Cleaning up
rm -f /tmp/.menu-cached-:0-xclient || :

echo Start X11
sudo --set-home -u ${X11_USER} Xvfb -screen 0 ${RESOLUTION} -ac &
sudo --set-home -u ${X11_USER} env DISPLAY=:0.0 x11vnc -forever -display :0 &
# Instead of VNC, one could also use rdp or nx here

echo Start the desktop
sudo --set-home -u ${X11_USER} env DISPLAY=:0.0 startlxde &

echo Start $@
sudo --set-home -u ${X11_USER} env DISPLAY=:0.0 $@
