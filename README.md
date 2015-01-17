Purpose
=======
Dockerfile for containerizing a graphical X11 applications. 

Details
=======

In the container runs a framebuffer X11 server. A VNC
server is connected to this X11 server. It should be
trivial to connect other remote desktop servers, like
RDP, Nomachine NX, Xpra, etc.

The X11 server runs a lightweight lxde desktop with
deacitvated screen server. Installed are only a 
X11 terminal and firefox.

Security
========

X11 applications are exposed via VNC on port 5900
The VNC port is unprotected. To protect it, one can
use a separete [ssh jump host][1]. An according 
[fig configuration][2] is in the example folder.

Alternatively you can publish the VNC remote desktop
as an [HTML5 GUI][3].

[1]: https://registry.hub.docker.com/u/geggo98/ssh-vpn-jump-host/
[2]: example/ssh/
[3]: example/guacamole/
