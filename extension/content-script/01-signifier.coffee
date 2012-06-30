#
# 	IMPORTANT THERE IS ALREADY A METHOD CALLED DELETER IN THE THIRD TAB!!!
# 	IMPORTANT THERE IS ALREADY A METHOD CALLED DELETER IN THE THIRD TAB!!!
#	logging boolean to turn on and off logging garbage

logging = true

# 	Need to start commenting a lot more of this stuff.
#
# 	ToDo:  	Direct connections with facebook and twitter to
# 			lower database load.

class Trace
	## I can't remember why I made this
	@loc: window.location

	@signsFound: false

	@alreadySent: false

	@deleteEntireDatabase: =>
		@socket.emit 'deleteTheWholeShebang'

	@findTextNode: (str, node) ->
		for child in node.childNodes when (child.textContent || "").indexOf(str) > -1
			if child.nodeType is 3
				if logging then console.log child
				return [child, child.data.indexOf(str)]
			else if child.nodeType is 1
				if logging then console.log "dove a level deeper with findTextNode"
				@findTextNode str, child

	@getNeighborhood: ->
		@socket.emit 'chillinAt',
			host: @loc.hostname,
			path: @loc.pathname
		@socket.on 'heresYourHood', (links) ->
			if logging
				console.log "response from heresYourHood!"
				console.log links
			Trace.queWorkingLinks links
			observer = new WebKitMutationObserver (mutations) ->
				if logging then console.log mutations
				window.mutations = mutations
				possibleElts = []

				# Function which checks if node is already a signifier.
				# We require the node to be a html element, so we climb up from text nodes if necessary.
				testNodeForSiggg = (node) ->
					if !(ref = $ node)
						if logging
							console.log "somehow found a node which gives an undefined jQuery object!  here's the node: "
							console.log node
						return true
					if node.nodeType = 3 then node = node.parentElement and ref = $ node
					return ref.hasClass("siggg")

				for mutation in mutations when mutation.addedNodes.length
					for node in mutation.addedNodes when testNodeForSiggg(node) isnt true
						if node.nodeType is 1 then possibleElts.push node
						else if node.nodeType is 3 then possibleElts.push node.parentElement
				if logging
					console.log "Here are the possibleElts of our mutations: "
					console.log possibleElts
				Trace.queWorkingLinks(links, node) for node in possibleElts when node.textContent isnt ""


			observer.observe(document.body, {childList: true, subtree: true})
						
	# Given a parent element, iterates over a list of links from couchDB looking for matching margin text.
	# Once margin text is found, fill in the link if we need to add one.
	@queWorkingLinks: (links, parent = document.body) ->

		Trace.fillInSign = (link, parent = document.body) ->
			if logging
				console.log "this is the link ->"
				console.log link
			actual = (possibles = $(parent).find("#{link.tag}:contains(#{link.margin})")).filter (ind) ->
				Trace.elementIsSmallest(@, possibles) and $(this).hasClass("siggg") isnt true
			if logging
				console.log "this is the possibles"
				console.log possibles
				console.log "this is the actuals: "
				console.log actual
			actual.each (ind) ->
				startInfo = Trace.findTextNode(link.startText || link.text, @)
				endInfo = Trace.findTextNode(link.endText || link.text, @)
				range = document.createRange()
				if logging
					console.log "here is our link info"
					console.log startInfo
					console.log endInfo
				range.setStart(startInfo[0], startInfo[1])
				range.setEnd(endInfo[0], endInfo[1] + (link.endText || link.text).length)
				wrapper = document.createElement 'a'
				wrapper.href = link.url
				wrapper.target = '_blank'
				range.surroundContents wrapper
				$(wrapper).addClass('signifier').addClass('siggg').data('sigId', link._id).data('sigRev', link._rev)
				$(this).addClass("siggg")
				if Trace.alreadySent isnt true
					chrome.extension.sendMessage({signStatus: (Trace.signsFound = true)}, (response) ->
						Trace.alreadySent = true
						console.log response
					)
			return actual

		if Array.isArray links.rows
			for a in links.rows when parent.textContent.indexOf(a.value.margin) isnt -1
				link = a.value
				Trace.fillInSign(link, parent)

	@elementIsSmallest: (elt, arr) ->
		for temp in arr when temp isnt elt
			if elt.contains(temp)
				return false
		return true


	@activate: ->
		console.log 'made it to Trace.activate()!' if logging
		Trace.socket = io.connect "http://www.sgnfier.com:7000"
		Sign.socket = Trace.socket
		Trace.socket.on 'whereYat', (data) ->
			console.log "whereYat recieved!" if logging
			Trace.getNeighborhood()
