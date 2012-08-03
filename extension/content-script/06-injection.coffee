$ ->
	chrome.extension.sendMessage({signStatus: Signifier.signsFound}, (response) ->
		console.log response if logging
	)
	Signifier.activate()
	Sign.activate()
	if logging
		return console.log "Signifier activated"
