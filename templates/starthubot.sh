#!/usr/bin/env bash

export ROCKETCHAT_AUTH=password
export ROCKETCHAT_USER=iris
export ROCKETCHAT_PASSWORD=tinaja#123
export ROCKETCHAT_ROOM=''
export ROCKETCHAT_URL=http://tinaja-chat:3000
export LISTEN_ON_ALL_PUBLIC=true

cd /opt/iris
bin/hubot -a rocketchat

