#
# 	IMPORTANT THERE IS ALREADY A METHOD CALLED DELETER IN THE THIRD TAB!!!
# 	IMPORTANT THERE IS ALREADY A METHOD CALLED DELETER IN THE THIRD TAB!!!
#	logging boolean to turn on and off logging garbage

logging = true

# 	Need to start commenting a lot more of this stuff.
#
# 	ToDo:  	Direct connections with facebook and twitter to
# 			lower database load.
#

class Signifier
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
				console.log "dove a level deeper with findTextNode" if logging
				return @findTextNode str, child

	@getNeighborhood: ->
		@socket.emit 'chillinAt',
			host: @loc.hostname,
			path: @loc.pathname
		@socket.on 'heresYourHood', (links) ->
			if logging
				console.log "response from heresYourHood!"
				console.log links
			Signifier.queWorkingLinks links


			#	This uses the WebKitMutationObserver object to figure out when dynamic content is added to the page.
			#	MutationObservers are incredibly general objects, so we have to do a lot of parsing through the data.
			#	----------------------------------------------------------------------------------------------------
			observer = new WebKitMutationObserver (mutations) ->
				possibleElts = []

				#	Sometimes the "when" part of loop comprehensions can get a little crazy, so the code gets moved to its own function.
				#	-------------------------------------------------------------------------------------------------------------------
				testNodeForSiggg = (node) ->
					if !(ref = $ node)
						if logging
							console.log "somehow found a node which gives an undefined jQuery object!  here's the node: "
							console.log node
						return true
					if node.nodeType = 3 then node = node.parentElement and ref = $ node	# Caughtcha text node! back to the parent
					return ref.hasClass("siggg")

				console.log mutations if logging
				window.mutations = mutations

				# Function which checks if node is already a signifier.
				# We require the node to be a html element, so we climb up from text nodes if necessary.
				# --------------------------------------------------------------------------------------
				
				for mutation in mutations when mutation.addedNodes.length
					for node in mutation.addedNodes when testNodeForSiggg(node) isnt true
						if node.nodeType is 1 then possibleElts.push node
						else if node.nodeType is 3 then possibleElts.push node.parentElement

				if logging
					console.log "Here are the possibleElts of our mutations: "
					console.log possibleElts
				Signifier.queWorkingLinks(links, node) for node in possibleElts when node.textContent isnt ""

			observer.observe(document.body, {childList: true, subtree: true})
						
	# Given a parent element, iterates over a list of links from couchDB looking for matching margin text.
	# Once margin text is found, fill in the link if we need to add one.
	@queWorkingLinks: (links, parent = document.body) ->

		Signifier.fillInSign = (link, parent = document.body) ->
			if logging
				console.log "this is the link ->"
				console.log link
			actual = (possibles = $(parent).find("#{link.tag}:contains(#{link.margin})")).filter (ind) ->
				Signifier.elementIsSmallest(@, possibles) and $(this).hasClass("siggg") isnt true
			if logging
				console.log "this is the possibles"
				console.log possibles
				console.log "this is the actuals: "
				console.log actual
			actual.each (ind) ->
				range = document.createRange()
				startInfo = Signifier.findTextNode(link.startText || link.text, this)
				endInfo = Signifier.findTextNode(link.endText || link.text, this)
				if logging
					console.log "here is our link info"
					console.log startInfo
					console.log endInfo
				range.setStart(
					startInfo[0],
					startInfo[1]
				)
				range.setEnd(
					endInfo[0],
					endInfo[1] + (link.endText || link.text).length
				)
				#	Now we create our link wrapper to place around with jQuery
				wrapper = document.createElement 'a'
				wrapper.href = link.url
				wrapper.target = '_blank'
				range.surroundContents wrapper
				$(wrapper).addClass('signifier')
					.addClass('siggg')
					.data('sigId', link._id)
					.data('sigRev', link._rev)
				$(this).addClass("siggg")
				if Signifier.alreadySent isnt true
					chrome.extension.sendMessage( signStatus: (Signifier.signsFound = true), (response) ->
						Signifier.alreadySent = true
						console.log response if logging
					)
			return actual

		if Array.isArray links.rows
			for a in links.rows when parent.textContent.indexOf(a.value.margin) isnt -1
				link = a.value
				Signifier.fillInSign(link, parent)

	@elementIsSmallest: (elt, arr) ->
		for temp in arr when temp isnt elt
			if elt.contains(temp)
				return false
		return true


	@activate: ->
		console.log 'made it to Signifier.activate()!' if logging

		# Testing version!
		# Signifier.socket = io.connect "http://127.0.0.1:7000"

		# Legit version
		Signifier.socket = io.connect "http://www.sgnfier.com:7000"

		Sign.socket = Signifier.socket
		Signifier.socket.on 'whereYat', (data) ->
			console.log "whereYat recieved!" if logging
			Signifier.getNeighborhood()
