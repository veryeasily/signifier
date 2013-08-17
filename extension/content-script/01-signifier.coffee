LOGGING = true
# DEVELOPMENT SERVER
# SOCKET_ADDRESS = "http://127.0.0.1:7000"

# PRODUCTION SERVER
SOCKET_ADDRESS = "http://larry.chatlands.com:7000"

#   ToDo: Direct connections with facebook and twitter
#     to lower database load.

# We do custom logging.
log = (logs...) ->
  console.log item for item in logs if LOGGING

Signifier =
  signsFound: false
  alreadySent: false

  findLink: (link, elt = document.body) ->
    text = link.margin
    return null unless ($elt = $(elt)).filter(":contains(#{text})").length
    $child = $elt
    checkChildren = -> $child.children(":contains(#{text})")
    ($child = checkChildren()).length and $elt = $child while $child.length
    return $elt[0]

  findTextNode: (str, node) ->
    for child in node.childNodes when (
      (text = child.textContent) and
      typeof text.indexOf is "function" and
      text.indexOf(str) > -1)
        while child.nodeType isnt 3
          log "dove a level deeper with findTextNode"
          return @findTextNode str, child
        log child
        return {node: child, index: child.data.indexOf(str)}

  getNeighborhood: ->
    @socket.emit 'chillinAt',
      host: window.location.hostname,
      path: window.location.pathname
    @socket.on 'heresYourHood', (response) =>
      log "response from heresYourHood!", response

      @response = response
      @links = links =
        if Array.isArray @response.rows
          row.value for row in response.rows
        else null
      for link in links
        if elt = @findLink(link)
          log elt
          @makeLink(link, elt)
          @removeLink(link)

      #  This uses the WebKitMutationObserver object to figure out when
      #  dynamic content is added to the page. MutationObservers are
      #  incredibly general objects, so we have to do a lot of parsing
      #  through the data.

      sig_id = 0
      targets = []
      observer = new WebKitMutationObserver (mutations) =>
        links = @links
        
        # We log added nodes. We don't use this now but probably will
        # in the future
        #
        # may want to eventually check removed nodes also
        mutations =
          mutation for mutation in mutations when(
            length = mutation.addedNodes.length)

        new_ones = false

        for mutation in mutations when(
          (target = mutation.target) and
          targets.indexOf(target) is -1)
          target.dataset['sigid'] ?= sig_id++
          targets.push target
          new_ones = true
        if mutations.length and new_ones
          for link in links
            if elt = @findLink(link)
              log elt
              @makeLink(link, elt)
              @removeLink(link)
        log "here's the targets they were added to", targets if targets.length

      observer.observe document.body,
        childList: true
        subtree: true
            
  removeLink: (link) ->
    links = @links
    i = links.indexOf(link)
    @links = links.slice(0, i)
      .concat links.slice(i + 1, length)
    return @links

  makeLink: (link, elt) ->
      range = document.createRange()
      startInfo = @findTextNode(link.startText || link.text, elt)
      endInfo = @findTextNode(link.endText || link.text, elt)
      log "here is our link info", startInfo, endInfo

      range.setStart(
        startInfo.node,
        startInfo.index
      )
      range.setEnd(
        endInfo.node,
        endInfo.index + (link.endText || link.text).length
      )

      #  Now we create our link wrapper to place around with jQuery
      wrapper = document.createElement 'a'
      wrapper.href = link.url
      wrapper.target = '_blank'
      range.surroundContents wrapper
      $(wrapper).addClass('signifier')
        .data('sigId', link._id)
        .data('sigRev', link._rev)
      $(this).addClass("signifier")

      found = true
      if Signifier.alreadySent isnt true
        chrome.extension.sendMessage signStatus: (Signifier.signsFound = true),
          (response) ->
            Signifier.alreadySent = true
            log response
      return found

  activate: ->
    log 'made it to Signifier.activate()!'

    window.body = document.body # just for shorthand

    # Legit version
    Signifier.socket = io.connect SOCKET_ADDRESS

    Sign.socket = Signifier.socket
    Signifier.socket.on 'whereYat', (data) ->
      log "whereYat recieved!"
      Signifier.getNeighborhood()

  deleteEntireDatabase: =>
    @socket.emit 'deleteTheWholeShebang'

