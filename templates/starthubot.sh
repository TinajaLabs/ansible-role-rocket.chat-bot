#!/usr/bin/env bash

export ROCKETCHAT_URL=http://tinaja-chat:3000

export ROCKETCHAT_ROOM='general'
export RESPOND_TO_DM=true
export ROCKETCHAT_USER=iris
export ROCKETCHAT_PASSWORD=tinaja#123
export ROCKETCHAT_AUTH=password


cd /opt/iris
bin/hubot -a rocketchat

