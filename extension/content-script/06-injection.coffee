$ ->
  Signifier.activate()
  Sign.activate()
  return log "Signifier activated"
  # chrome.extension.sendMessage(signStatus: Signifier.signsFound, (response) ->
  #   log response
  # )
