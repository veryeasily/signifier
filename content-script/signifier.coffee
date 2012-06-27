#
# IMPORTANT THERE IS ALREADY A METHOD CALLED DELETER IN THE THIRD TAB!!!
# IMPORTANT THERE IS ALREADY A METHOD CALLED DELETER IN THE THIRD TAB!!!
# logging boolean to turn on and off logging garbage
#
logging = true

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
			Signifier.queWorkingLinks links
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
				startInfo = Signifier.findTextNode(link.startText || link.text, @)
				endInfo = Signifier.findTextNode(link.endText || link.text, @)
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
				if Signifier.alreadySent isnt true
					chrome.extension.sendMessage({signStatus: (Signifier.signsFound = true)}, (response) ->
						Signifier.alreadySent = true
						console.log response
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
		Signifier.socket = io.connect "http://www.sgnfier.com:7000"
		Sign.socket = Signifier.socket
		Signifier.socket.on 'whereYat', (data) ->
			console.log "whereYat recieved!" if logging
			Signifier.getNeighborhood()

class Sign

	@findContainingChild: (parent, elt) ->
		for child in parent.childNodes
			return child if child.contains elt

	@getChildIndex: (elt) ->
		e = elt
		k = 0
		++k while e = e.previousSibling
		k

	@getOffsetToNode: (parent, elt) =>
		if parent is elt
			console.log "returning without reducing"
			return 0
		else
			goddamn = (a for a in parent.childNodes)
			child = @findContainingChild(parent, elt)
			offset = _.foldl goddamn[0...@getChildIndex child], ((memo, node) -> memo + node.textContent.length), 0
			if elt.parentNode isnt parent
				offset+= @getOffsetToNode(@findContainingChild(parent, elt), elt)
			console.log "offset being returned from @getOffsetToNode is: #{offset}"
			return offset

	@getMargin: (range) =>
		console.log "range is ="
		console.log range
		startOffset = @getOffsetToNode(range.commonAncestorContainer, range.startContainer) + range.startOffset
		console.log "startOffset = #{startOffset}"
		endOffset = @getOffsetToNode(range.commonAncestorContainer, range.endContainer) + range.endOffset
		console.log "endOffset = #{endOffset}"
		left = Math.max(0, startOffset - 10)
		right = Math.min(range.commonAncestorContainer.textContent.length, endOffset + 10)
		console.log "here is the index of our margin"
		console.log [left, right]
		console.log "here is range.commonAncestorContainer.textContent"
		console.log range.commonAncestorContainer.textContent
		console.log "here is our margin!"
		console.log (send = range.commonAncestorContainer.textContent.slice(left, right))
		send

	constructor: () ->

		sel = document.getSelection()
		console.log "made it to the try"
		try
			if sel.type isnt "Range"
				alert "no selection!"
				return
			range = sel.getRangeAt(0)
			if (parent = @parent = range.commonAncestorContainer).nodeType is 3 then (parent = @parent = parent.parentElement)
			if range.startContainer.parentElement isnt range.endContainer.parentElement
				alert "select something simpiler"
				return
			if (range.startContainer.nodeType isnt 3) or (range.endContainer.nodeType isnt 3)
				alert "we only can select text to turn to links for right now"
				return
		catch error
			throw error
		url = prompt("give link url", "http://www.awebsite.com")
		console.log "made it past the try"
		{startContainer: start, startContainer: {textContent: startStr}, endContainer: end, endContainer: {textContent: endStr}} = range = sel.getRangeAt 0
	
		@toDB =
			tag: parent.tagName
			text: range.toString()
			startText: range.toString()
			endText: range.toString()
			margin: Sign.getMargin(range)
			url: url
			host: document.location.hostname
			path: document.location.pathname

		if range.startContainer isnt range.endContainer
			console.log "trying to slice each container"
			@toDB.startText = startStr.slice range.startOffset, startStr.length + 1
			@toDB.endText = endStr.slice 0, range.endOffset
		console.log "#{@toDB.startText} is startText, #{@toDB.endText} is endText"
		thing = document.createElement('a')
		thing.href = url
		thing.target = '_blank'
		range.surroundContents(thing)
		$(thing).addClass("signifier").addClass("siggg")
		$(parent).addClass("siggg")

		Sign.socket.emit("heresASign", @toDB)

	@activate: ->
		chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
			makeSign = ->
				sign = new Sign()
			do makeSign if request.greeting is "makeSign"
		chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
			removeSign = ->
				Deleter.removeSigsInSel()
			do removeSign if request.greeting is "removeSign"
class Deleter

	@removeSigsInSel: ->
		sel = document.getSelection()
		range = sel.getRangeAt 0
		parent = range.commonAncestorContainer
		for a in $(parent).find("a.siggg")
			if sel.containsNode(a)
				id = $(a).data('sigId')
				rev = $(a).data('sigRev')
				b = a.childNodes[0]
				$(b).unwrap()
				Signifier.socket.emit 'delete', {id: id, rev: rev}
				if logging
					console.log "sig attempted to be deleted"
					console.log a
$ ->
	chrome.extension.sendMessage({signStatus: Signifier.signsFound}, (response) ->
		console.log response
	)
	Signifier.activate()
	Sign.activate()
	return console.log "Signifier activated" if logging
class SigHelpers

	SigHelpers.getTextNodes = (elt) ->
		SAT = (node) ->
			if node.nodeType is 3
				return node
			else
				results = [].concat (temp for sn in node.childNodes when (temp = SAT(sn)).length)...
				return results
		SAT elt

	SigHelpers.addUpTextLengths = (txtNodeArr) ->
		r = 0
		for a in txtNodeArr
			r += a.textContent.length
		return r

	SigHelpers.getTextNodeFromIndex = (arr, num) ->
		r = 0
		i = 0
		++i while (r+= arr[i].textContent.length) < num
		return arr[i]

	SigHelpers.getIndexOfContainingChild = (parent, node) ->
		arr = new Array(parent.childNodes...)
		child = arr[0]
		child = child.nextSibling while !child.contains?(node)
		return child
