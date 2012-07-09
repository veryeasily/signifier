io = require('socket.io').listen(7000)
nano = require('nano')('http://127.0.0.1:5984')
db_name = "signifier"
db = nano.use db_name

io.sockets.on 'connection', (socket) ->

	address = socket.handshake.address
	console.log "here is the address!: "
	console.log address

	class Signifier
		constructor: ->

		@socket: socket

		@scoutHood: (imAt) ->
			console.log "querying db with [host,path] = "
			console.log [imAt.host, imAt.path]
			db.view('signifier', 'neighborhood', {key: [imAt.host, imAt.path]}, (err, signs) ->
				console.log (signs)
				Signifier.socket.emit("heresYourHood", signs))

		@sendSigns: (signs) ->
			Signifier.socket.emit("heresYourHood", signs)

		@deleteAllDocs: ->
			db.view('signifier', 'neighborhood', (err, body) ->
				if err
					console.log err
					return
				for a in body.rows
					doc = a.value
					db.destroy(doc._id, doc._rev, (err, body) ->
						console.log err or body
					)
				console.log "database purged successfully!"
			)


	socket.emit('whereYat', {header: null})
	console.log 'whereYat just sent'
	socket.on 'chillinAt', (imAt) ->
		Signifier.scoutHood(imAt)
	socket.on "heresASign", (sign) ->
		sign.creator = {
			ip: socket.handshake.address.address
		}
		db.insert sign, (err, body, headers) ->
			if err is false
				console.log headers, body
	socket.on "delete", (sig) ->
		db.destroy sig.id, sig.rev, (err, body) ->
				console.log err
				console.log body
				if !err then console.log "sig successfully deleted"
	socket.on "deleteTheWholeShebang", ->
		Signifier.deleteAllDocs()
