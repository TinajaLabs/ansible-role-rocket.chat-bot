Ansible Rocket.Chat with Hubot
===============================

A simple Ansible role to install Rocket.Chat with a bot, Hubot, on a Raspberry Pi. Yep, a chat system running in your home. Hubot is from the folks at [Gitlab - Hubot](https://hubot.github.com/)  The Hubot software can be used to code a bot (software robot).  The bot, acting as a user in the chat system, can be programmed to act on your command to activate and respond to smart devices in your home.

The Ansible playbook/role uses snapd to install Rocket.chat and uses a standard set of other commands to install and configure Hubot.

In my system, I've named my bot, Iris, so any references to that is just my preference.


Requirements
------------

Designed and tested with: 

* Raspberry Pi 3 Model B V1.2 running minimal version of Raspbian Stretch.
* git needs to be installed on the taget Raspberry Pi ??


Role Variables
-------------
```
# defaults file for tinajalabs.chatbot

nodejs_version: "8.x"  # or, 10.x

hubot_rocketchat_version: "1.0.12"

bot_name: "bot"
bot_owner: "{{ bot_name }} {{ bot_name }}@{{ domain.com }}"
bot_dir: "/opt/{{ bot_name }}"
bot_desc: "Go ask Iris, when she's ten feet tall "
```


Dependencies
------------

* Git on the target machine - It seems that the Rocket.Chat Adapter requires git.  I have another ansible playbook that loads a baseline setup for all my Reapberry Pis and it installs git.


Example Playbook
----------------

Create playbook, for example, `tinaja-chat.yml` with this content:

```
---

  - hosts: tinaja-chat
    become: yes


    #-----------------------------------------------------------
    vars:
      nodejs_version: "8.x" 

      hubot_rocketchat_version: 1.0.12

      bot_name: "iris"
      bot_owner: "iris iris@tinajalabs.com"
      bot_desc: "A bot that represents your home"


    #-----------------------------------------------------------
    roles:

    - {role: tinajalabs.tinaja}

```


Basic Steps
-------------

* Install Ansible - will assume this is already done...
* Download the latest version of the Raspbian image from: https://downloads.raspberrypi.org/raspbian_lite_latest
* Burn the image on a MicroSD card (8G or more) using [etcher](https://www.balena.io/etcher/)
* Add a magic empty file named SSH onto the boot partition (configures default SSH service)
* Plug in the MicroSD image into the Raspi and boot up.
* After bootup, copy your public key to the raspberrypi using `user:pi`, `password:raspberry`:
 `$ ssh-copy-id -f -i ~/.ssh/id_rsa.pub pi@raspberrypi.local`

* Create a host inventory file with a reference like this:
`tinaja-chat ansible_host=<raspi ipaddress> ansible_user=pi`

* Run your playbook:
`$ ansible-playbook tinaja-chat.yml -i hosts/hosts.ini -u pi -b -c ssh`


**Run these tests after rebooting the Raspberry Pi:**

Wait about 2 - 3 minutes for Rocket.Chat and Hubot to connect to each other.  It takes a long time and hubot needs Rocket.Chat to be running to make the connection.


* Find rocket.chat web UI at:
`http://raspiIp:3000`

At first launch:
* set up an Admin User - follow instructions
* set up Organization
* add a User with Role of `bot`  (with the same name as bot_name)

Test that the bot is active by asking for help:
`iris help`


To log into your raspi at a terminal command line:
`$ ssh pi@raspberrypi.local`

Find the hubot software and server at /opt/<bot_name>
`$ cd /opt/iris`

Launch the command line bot:
`$ bin/hubot`

At the iris prompt, type `iris help` to see  the list of default commands.
`iris> iris help`

To see the status of the Hubot service:
`$ systemctl status hubot.service`

To see the status of Rocket.Chat:
`$ systemctl status snap.rocketchat-server.rocketchat-server.service`


Hubot Scripts
-------------
Look at the directory, `/opt/iris/scripts` and see sample coffee scripts.  Modify and extend these for your own bot commands.


References
-----------
* How Ansible Works - https://www.ansible.com/overview/how-ansible-works
* Get Started with Ansible - https://docs.ansible.com/ansible/latest/network/getting_started/first_playbook.html
* Hubot Documentation - https://hubot.github.com/docs/
* Rocket.Chat with Bots - https://rocket.chat/docs/bots/
* 

ToDo:
-----
* find a way to automate the addition of the admin usr, the bot user
* research why it takes rocket.chat so long to start.


License
-------
MIT


Author Information
------------------
Chris Jefferies - `chris@tinajalabs.com`

