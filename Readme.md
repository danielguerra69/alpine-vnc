# About
x11vnc on alpine linux

# Usage
docker run -d -p 5900:5900 danielguerra/alpine-vnc

After this use vnc-client to connect to your alpine.
Right click shows the menu

Every runs as user alpine. This user has sudo rights.
The password=alpine you can change is with passwd in
the xterm.
