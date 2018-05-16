#!/bin/sh

sudo docker run -it\
    --rm \
    --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
    --env DISPLAY=unix$DISPLAY \
    --env TZ=CST6CDT \
    --shm-size 2g \
    telegram $@
