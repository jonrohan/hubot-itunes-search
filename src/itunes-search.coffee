# Description
#   Search iTunes for music, and return previews
#
# Commands:
#   hubot music single ladies - will search for the iTunes link to Single Ladies
#
# Author:
#   Jon Rohan <jon@jonrohan.me>

module.exports = (robot) ->

  robot.respond /music( me)? (.+)/i, (msg) ->
    query = msg.match[2]
    robot.http("http://itunes.apple.com/search")
      .query({
        entity: "song",
        limit: "1",
        term: query
      })
      .get() (err, res, body) ->

        return msg.send "Error :: #{err}" if err
        try
          songs = JSON.parse(body)
        catch error
          return msg.send "Error :: iTunes api error."

        return msg.send "No tracks found." if songs.resultCount == 0
        track = songs.results[0]

        msg.send track.trackViewUrl
        msg.send track.artworkUrl100 unless robot.adapterName == "slack"
        msg.send "*#{track.trackName}*\n#{track.artistName} — #{track.collectionName}"
        msg.send track.previewUrl
