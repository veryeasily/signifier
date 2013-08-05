SOCKET_IO_PORT = 7000
io = require('socket.io').listen(SOCKET_IO_PORT)
nano = require('nano')('http://127.0.0.1:5984')
DB_NAME = "signifier"
db = nano.use DB_NAME
LOGGING = true

# Here we construct the main class, Signifier. The naming gets a
# little silly but helps me think.
class Signifier
  constructor: (@socket) ->

  # After we get a response Signifier checks with CouchDB to see
  # which signs correspond to host and path.
  scoutHood: (imAt) ->
    if LOGGING
      console.log "querying db with [host,path] = "
      console.log [imAt.host, imAt.path]

    db.view 'signifier', 'neighborhood',
      {keys: [[imAt.host, imAt.path]]}, (err, signs) =>
        if err then console.log err
        else if LOGGING
          console.log signs
        (console.log this) if LOGGING
        (console.log @socket) if LOGGING
        
        @socket.emit "heresYourHood", signs

  # This function allows us to quickly delete CouchDB because they
  # make that a pain for some reason. If there is a more efficient
  # way to do this, please let me know.
  deleteAllDocs: ->
    db.view 'signifier', 'neighborhood', (err, body) ->
      if err
        console.log err
        return

      for key in body.rows
        doc = key.value
        db.destroy doc._id, doc._rev, (err, body) ->
          console.log err or (body if LOGGING)
      console.log "database purged successfully!" if LOGGING


io.sockets.on 'connection', (socket) ->
  # We check the IP of the user. This is important to track down vandalism,
  # and also if in the future we want to implement some type of user upvoting feature.
  sig = new Signifier socket
  address = socket.handshake.address

  if LOGGING
    console.log "here is the address!: "
    console.log address

  socket.emit 'whereYat', header: null
  console.log 'whereYat just sent' if LOGGING

  socket.on 'chillinAt', (imAt) ->
    sig.scoutHood imAt

  socket.on "heresASign", (sign) ->
    sign.creator = ip: socket.handshake.address.address
    db.insert sign, (err, body, headers) ->
      if err then (console.log headers, body) else console.log err

  socket.on "delete", (sig) ->
    db.destroy sig.id, sig.rev, (err, body) ->
    if LOGGING
      console.log body
      unless err then console.log "sig successfully deleted"
      else err

  socket.on "deleteTheWholeShebang", ->
    sig.deleteAllDocs()
