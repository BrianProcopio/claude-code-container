#!/bin/bash
# Start virtual framebuffer
Xvfb :99 -screen 0 1920x1080x24 &
# Start window manager
fluxbox &
# Start VNC server (no password, listen on 5900)
x11vnc -display :99 -forever -nopw -quiet &
# Start noVNC web client (port 6080 → VNC 5900)
websockify --web /usr/share/novnc 6080 localhost:5900 &
# Hand off to bash
exec /bin/bash
