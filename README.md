# LogitechMediaServer

A docker Logitech Media Server

For running the docker-compose as a systemd Unit, refer to the following:
https://github.com/docker/compose/issues/4266#issuecomment-302813256

Note:
If using a bridge, the discovery will not work,
(broadcast isn't working on docker driver bridge).
Meaning that you will need to configure all your clients accordingly.


