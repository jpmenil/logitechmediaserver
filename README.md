# LogitechMediaServer

A docker Logitech Media Server

For running the docker-compse as a systemd Unit, refer to the following:
https://github.com/docker/compose/issues/4266#issuecomment-302813256

N.B:
This docker-compose use a bridge, meaning that discovery of the server will not
work, since broadcast isn't working on docker driver bridge.
