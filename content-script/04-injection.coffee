$ ->
	chrome.extension.sendMessage({signStatus: Signifier.signsFound}, (response) ->
		console.log response
	)
	Signifier.activate()
	Sign.activate()
	return console.log "Signifier activated" if logging
