$ ->
  chrome.extension.sendMessage({signStatus: Signifier.signsFound}, (response) ->
    console.log response if LOGGING
  )
  Signifier.activate()
  Sign.activate()
  if LOGGING
    return console.log "Signifier activated"
