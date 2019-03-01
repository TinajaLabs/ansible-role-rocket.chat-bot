# Description:
#   <description of the scripts functionality>
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>

url = require('url')
querystring = require('querystring')


module.exports = (robot) ->

  robot.router.get "/tinaja/alexa", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    user = {}
    user.room = query.room if query.room

    try
       robot.send user, "Update:  " + query.message

       res.end "message sent: #{query.room}, #{query.message}"

    catch error
      # console.log "message-listener error: #{error}."
      robot.emit 'error', err

