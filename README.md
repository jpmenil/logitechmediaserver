# LogitechMediaServer

A docker Logitech Media Server

For running the docker-compose as a systemd Unit, refer to the following:
https://github.com/docker/compose/issues/4266#issuecomment-302813256

N.b:
This docker-compose use a bridge, meaning that discovery of the server will not
work, since broadcast isn't working on docker driver bridge.
You now have three solutions:
- Do not use it
- Configure your clients
- Set network: host into your docker-compose

