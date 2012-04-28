
# let's start off this thing!!
# this is our current IP address which we will change soon
$.couch.urlPrefix = "http://127.0.0.1:5984"

# I'm trying to be object oriented?
class Database
	constructor: ->
		@site = document.location
		@couch = $.couch.db('signifier')

	getLinks: ->
		@couch.view('signifier/links',
			success: (data) ->
				console.log 'data recieved from getLinks: !'
				console.log data
				Signifier.checkForSignifier data
				undefined
			error: (err) ->
				console.log 'error!'
				console.log err
				undefined
			key: [@site.hostname, @site.pathname])
		return undefined

class Signifier
	### constructor: (hostname, pathname) ->
		@doc = document.documentElement
		@html = @doc.innerHTML
		@db = new Database()
	###
	this.doc = document.documentElement
	this.html = @doc.innerHTML
	this.db = new Database()

	this.checkForSignifier = (data) ->
		console.log 'made it into checkForSignifier! here is the data argument:'
		console.log data
		count = 0
		workingLinks = []
		workingLinks = for content in data.rows
			console.log 'here is a row of our data from the initial:'
			console.log content
			if window.find content.value, false, false, true
				console.log 'found on page: '
				console.log content.value
				content.id
			else null
		workingLinks = workingLinks.filter (elt) -> elt?
		@grabLinkData workingLinks

	@grabLinkData: (arr) ->
		linkList = []
		count = 0
		for linkID in arr
			@db.couch.openDoc linkID,
				success: (dat) =>
					linkList.push dat
					count++
					@getTextLocation linkList if count is arr.length
					null
				error: (err) =>
					console.log 'Error getting full link from DB!:'
					console.log err
					null


	@selectionIsValid = () ->
		select = getSelection()
		range = select.getRangeAt 0
		console.log 'range.toString!: '
		console.log range.toString().length
		if select.anchorNode is select.focusNode and range.toString().length isnt 0 then return range else return null

	@getTextLocation: (arr) ->
		for link in arr
			@html = @doc.innerHTML
			marginLoc = @html.indexOf link.margins
			start = @html.indexOf link.text, marginLoc
			end = start + link.text.length
			console.log 'made it through get TextLocation with textLoc = '
			console.log [start, end]
			textLoc = [start, end]
			@insertLinks textLoc, link
		textLoc

	@insertLinks: (loc, data) ->
		#	console.log 'link being inserted!'
		document.documentElement.innerHTML = @html.slice(0, loc[0]) + "<a href='#{data.link}'>" + data.text + "</a>" + @html.slice(loc[1], @html.length)
		$(document.body).mousedown (ev) =>
			console.log 'screen clicked!  this was set within Signifier.  mouse button is:'
			console.log ev.which
			@makeLink ev if ev.which is 3

	@makeLink: (ev) ->
		console.log 'made it into makeLink!'
		return if (range = Signifier.selectionIsValid())? isnt true
		linkedSite = if (linkedSite = prompt 'enter hyperlink address', 'http://www.awebsite.com').substr(0, 4) is 'http' then linkedSite else linkedSite = 'http://' + linkedSite
		link = document.createElement 'a'
		console.log 'here is linkedSite! :'
		console.log linkedSite
		data =
			text: range.toString()
			loc: new Object null
			hostname: @db.site.hostname
			pathname: @db.site.pathname
			link: (link.href = linkedSite)
			margins: @_getMargins(range).toString()
		range.surroundContents link
		###
			log the data to upload to DB if necessary
			console.log data
		###
		@db.couch.saveDoc data,
			success: (res) ->
				###
					console.log "success!"
					console.log res
				###
			error: (err) ->
				###
					console.log "error!"
					console.log err
				###
	
	makeLink: @makeLink

	@_getMargins: (range) ->
		lMargin = if (shLMargin = range.startOffset - 20) >= 0 then shLMargin else 0
		rMargin = if (shRMargin = range.endOffset + 20) <= range.endContainer.length then shRMargin else range.endContainer.length
		marginRange = range.cloneRange()
		marginRange.setStart range.startContainer, lMargin
		marginRange.setEnd range.endContainer, rMargin
		marginRange

	_getMargins: @_getMargins

$ () ->

	site = document.location
	signifier = new Signifier site.hostname, site.pathname
	
	###

	WARNING!! :
	-----------------------------------------------------------
	USE THIS METHOD TO DELETE ALL THE DOCUMENTS ON THE DATABASE
	-----------------------------------------------------------

	signifier.db.couch.allDocs
		success: (data) ->
			console.log 'allDocs query loaded!:'
			console.log data
			for doc in data.rows
				if doc.id.substr(0,4) isnt '_des'
					dx =
						_id: doc.id
					dx._rev = doc.value.rev if doc.value.rev?
					signifier.db.couch.removeDoc dx,
						success: (info) ->
							console.log 'document removed'
							console.log info
							null
						error: (err) ->
							console.log 'some type of error!:'
							console.log err
							null
				null
		error: (err) ->
			console.log 'error querying db for allDocs!:'
			console.log err
	
	###
	
	console.log 'here is what our Signifier object looks like: '
	console.log signifier
	window.setTimeout( ->
		signifier.db.getLinks()
	, 2000)
	$(document.body).mousedown (ev) ->
		console.log 'screen clicked!  mouse button is:'
		console.log ev.which
		signifier.makeLink ev if ev.which is 3
