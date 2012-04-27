
# let's start off this thing!!
# this is our current IP address which we will change soon
$.couch.urlPrefix = "http://127.0.0.1:5984"

# I'm trying to be object oriented?
class Database
	constructor: ->
		@site = document.location
		@couch = $.couch.db('signified')

	getLinks: ->
		@couch.view('signified/links',
			success: (data) -> Signified.checkForSignifier data
			error: (err) ->
				console.log 'error!'
				console.log err
			key: [@site.hostname, @site.pathname])
		return null

class Signified
	constructor: (hostname, pathname) ->
		@db = new Database()
		@doc = document.documentElement
		@html = @doc.innerHTML

	this.checkForSignifier = (data) ->
		for content in data.rows when find content.value is true
			@db.couch.openDoc content.id,
				success: (dat) =>
					@getTextLocation dat
					null
				error: (err) =>
					console.log 'Error getting full link from DB!:'
					console.log err
					null
			content

	this.selectionIsValid = () ->
		select = getSelection()
		range = select.getRangeAt 0
		console.log 'range.toString!: '
		console.log range.toString().length
		if select.anchorNode is select.focusNode and range.toString().length isnt 0 then return range else return null

	getTextLocation: (data) ->
		marginLoc = @html.indexOf data.margins
		start = @html.indexOf data.text, marginLoc
		end = start + data.text.length
		###
			console.log 'made it through get TextLocation with textLoc = '
			console.log [start, end]
			textLoc = [start, end]
		###
		@insertLinks textLoc, data
		textLoc

	insertLinks: (loc, data) ->
		#	console.log 'link being inserted!'
		document.documentElement.innerHTML = @html.slice(0, loc[0]) + "<a href='#{data.link}'>" + data.text + "</a>" + @html.slice(loc[1], @html.length)
		$(document.body).mousedown @makeLink

	makeLink: (ev) ->
		console.log 'made it into makeLink!'
		return if (range = Signified.selectionIsValid())? isnt true
		linkedSite = if (linkedSite = prompt 'enter hyperlink address', 'http://www.awebsite.com').substr 0, 4 is 'http' then linkedSite else linkedSite = 'http://' + linkedSite
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

	_getMargins: (range) ->
		lMargin = if (shLMargin = range.startOffset - 20) >= 0 then shLMargin else 0
		rMargin = if (shRMargin = range.endOffset + 20) <= range.endContainer.length then shRMargin else range.endContainer.length
		marginRange = range.cloneRange()
		marginRange.setStart range.startContainer, lMargin
		marginRange.setEnd range.endContainer, rMargin
		marginRange

$ () ->
	site = document.location
	signified = new Signified site.hostname, site.pathname
	console.log 'here is what our Signified object looks like: '
	console.log signified
	signified.db.getLinks()
	$(document.body).mousedown (ev) ->
		console.log 'screen clicked!  mouse button is:'
		console.log ev.which
		signified.makeLink ev if ev.which is 3
