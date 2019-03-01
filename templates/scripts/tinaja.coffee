# Description:
#   Tinaja Labs script to show off Hubot
#
# Dependencies:
#   none
#
# Commands:
#   iris `list rooms` - Displays all rooms referenced in the home automation system.
#   iris `list devices in <room>` - Displays all devices that match <room>.
#   iris `turn on/off <device> in <room>` - Turns on/off a device in a room
#   iris `turn on/off all <device>` - Turns on/off all devices in the house
#   
#   
#   
#
# URLS:
#
# Notes:
#
# Author:
#   chrisj


# mqtt = require('mqtt')
# client  = mqtt.connect('http://mf-tinaja-co')
# topic = "home/kitchen/esp8266/switch"
# msg = "xxx"

# client.on('connect', () ->
#   client.subscribe(topic)
#   client.publish('presence', 'Hello mqtt')
# )

# client.on('message', (topic, message) ->
#   # ob = JSON.parse(message)
#   # dt = new Date(Number(ob.date))
#   msg = message.toString()
#   console.log(message.toString())
#   client.end()
# )

# querystring = require 'querystring'


module.exports = (robot) ->

  # look at msg.match for more complex regex

  # robot.router.get '/hubot/tl', (req, res) ->
  #   q = querystring.parse req._parsedUrl.query
  #   user = {}
  #   user.type = 'groupchat'
  #   user.room = q.room or '109614_playground@conf.hipchat.com'

  #   robot.send user, q.msg
  #   res.end "GET: received '#{q.msg}'"


  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"


  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"
  

  robot.hear /I like pie/i, (res) ->
    res.emote "makes a freshly baked pie"


  # hubot greeting.
  # (hi|hello) - say hi to your butler
  robot.respond /hi|hello/i, (msg) ->
    msg.send "Howdy!"

  robot.hear /tired|too hard|to hard|upset|bored/i, (msg) ->
    msg.send "Panzy"





module.exports = (robot) ->

  # list the rooms
  robot.respond /list rooms/i, (msg) ->

    msg.send "Retrieving list of rooms in the home.  Please wait..."

    # robot.http("http://mf-tinaja-co:1880/devicelist?state=#{lightState}&device=#{deviceName}&location=#{deviceLocation}").get() (err, res, body) ->

    msg.http("http://mf-tinaja-co:1880/roomlist")
    .get() (err, res, body) -> 

      try
        json = JSON.parse(body)

        thislist = "You have the following rooms defined in your home:\n"
        for device in json.payload
          # msg.send "#{device.room}"
          # console.log(device.room +"-"+ device.device)
          thislist = thislist + "`#{device.room}`, "

        msg.send "#{thislist}"

      catch error
        msg.send "Sorry, I am confused and could not find anything...(#{error})"


  # list the devices in room
  robot.respond /list devices in (.*)/i, (msg) ->
    deviceRoom = msg.match[1]
    msg.send "Listing devices in the #{deviceRoom}.  Please wait..."

    msg.http("http://mf-tinaja-co:1880/devicelist")
    .get() (err, res, body) -> 

      try
        json = JSON.parse(body)

        thislist = "The following devices were found in your #{deviceRoom}: "
        for device in json
          if device.room is deviceRoom.trim()
            thislist = thislist + "`#{device.device}`, "

        msg.send "#{thislist}"

      catch        
        msg.send "Sorry, I am confused and could not find anything...(#{error})"



  # turn on/off a device
  robot.respond /turn (.*) (.*) in (.*)/i, (msg) ->
    deviceState = msg.match[1]
    deviceName = msg.match[2]
    deviceRoom = msg.match[3]
    msg.send "I'm turning #{deviceState} the #{deviceName} in your #{deviceRoom}.  Please wait..."

    # build the full topic here and send it back to be http processed.

    msg.http("http://mf-tinaja-co:1880/setdevice?device=#{deviceName}&room=#{deviceRoom}&state=#{deviceState}")
      .get() (err, res, body) -> 

        msg.send "Node-RED confirmed receipt of message with the following payload:\n #{body}"
        # try
        #   json = JSON.parse(body)

        #   thislist = "Devices in your #{deviceLocation}: "
        #   for device in json.payload
        #     if device.room is deviceLocation
        #       thislist = thislist + "`#{device.device}`, "

        #   msg.send "#{thislist}"

        # catch error
        #   msg.send "Sorry, I am confused and could not find anything..."

  

  # get a chart of temps
  # http://mf-tinaja-gr:8081/render?target=aliasByNode(movingMedian(home.*.tinaja.M1.*.1%2C%20%2710min%27)%2C%204%2C%201)&from=-24h&until=now&format=png&maxDataPoints=1137&width=928&height=148&bgcolor=1f1f1f&fgcolor=BBBFC2&lineWidth=1&hideLegend=false&yUnitSystem=si
  robot.respond /chart temps/i, (msg) ->
    
    # msg.http("http://mf-tinaja-gr:8081/render?target=aliasByNode(movingMedian(home.*.tinaja.M1.*.1%2C%20%2710min%27)%2C%204%2C%201)&from=-24h&until=now&format=png&maxDataPoints=1137&width=928&height=148&bgcolor=1f1f1f&fgcolor=BBBFC2&lineWidth=1&hideLegend=false&yUnitSystem=si")
    #   .get() (err, res, body) -> 

    url = "http://mf-tinaja-gr:8081/render?target=aliasByNode(movingMedian(home.*.tinaja.M1.*.1%2C%20%2710min%27)%2C%204%2C%201)&from=-24h&until=now&format=png&maxDataPoints=1137&width=928&height=148&bgcolor=1f1f1f&fgcolor=BBBFC2&lineWidth=1&hideLegend=false&yUnitSystem=si"

    msg.send "Here's the chart of room temperatures for the last 24 hours:"
    # msg.send "#{url}#.png"
    msg.send "https://imgs.xkcd.com/comics/singularity.png"



  robot.respond /gem whois (.*)/i, (msg) ->
    gemname = escape(msg.match[1])
    msg.http("http://rubygems.org/api/v1/gems/#{gemname}.json")
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)


          msg.send "   gem name: #{json.name}\n
     owners: #{json.authors}\n
       info: #{json.info}\n
    version: #{json.version}\n
  downloads: #{json.downloads}\n"
        catch error
          msg.send "Gem not found. It will be mine. Oh yes. It will be mine. *sinister laugh*"



  # robot.hear /turn (.*)/i , (res) ->
  #   lightState = res.match[1]
  #   res.send "turning mochad #{lightState} "

  #   robot.http("http://mf-tinaja-co:1880/mochad?test=#{lightState}").get() (err, res, body) ->
  #   # error checking code here

  #   res.send "Got back #{body}"
  #   # res.send "Mochad? Mochad? WE DON'T NEED NO STINKIN Mochad"




