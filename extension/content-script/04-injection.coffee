$ ->
	chrome.extension.sendMessage({signStatus: Trace.signsFound}, (response) ->
		console.log response
	)
	Trace.activate()
	Sign.activate()
	return console.log "Trace activated" if logging
