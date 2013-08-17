$ ->
  chrome.extension.sendMessage({signStatus: Signifier.signsFound}, (response) ->
    log response
  )
  Signifier.activate()
  Sign.activate()
  return log "Signifier activated"
