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

#  A sign is what we add to the database whenever somebody makes a new link.
#  It contains a copy of the links URL, the host and path where the selected
#  text was located, information about the text that was selected, and a margin
#  around the text to make sure we find the right guy when we search for it later.
#
#  Because of complications with the range object, I store the tag name of the
#  CommonAncestor HTML element that contains the entire selection.  I also store
#  the parent element for the textNode that the selection begins and terminates in.
#  An important part of working with these range objects is to realize the difference
#  between 'elements' and 'nodes'.  Elements can only be HTML tags and not the variety
#  of other options.
#
#  For future reference, CAC = CommonAncestorContainer

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
      log "returning without reducing"
      return 0
    else
      goddamn = (a for a in parent.childNodes)
      child = @findContainingChild(parent, elt)
      offset = _.foldl goddamn[0...@getChildIndex child], ((memo, node) -> memo + node.textContent.length), 0
      #  ^^ This is the only time I use underscore.js in the extension?
      if elt.parentNode isnt parent
        offset+= @getOffsetToNode(@findContainingChild(parent, elt), elt)
      log "offset being returned from @getOffsetToNode is: #{offset}"
      return offset

  @getMargin: (range) =>
    log "range is =", range

    #  Calculates the offset through ALL child nodes of the CAC to range.startContainer (a text node)
    startOffset = @getOffsetToNode(range.commonAncestorContainer, range.startContainer) + range.startOffset
    log "startOffset = #{startOffset}"


    #  Same deal here but with range.endContainer
    endOffset = @getOffsetToNode(range.commonAncestorContainer, range.endContainer) + range.endOffset
    log "endOffset = #{endOffset}"


    #  Grab 10 letters to the left and right of the selection unless we're out of room
    left = Math.max(0, startOffset - 10)
    right = Math.min(range.commonAncestorContainer.textContent.length, endOffset + 10)
    log "here is the index of our margin",
      [left, right],
      "here is range.commonAncestorContainer.textContent",
      range.commonAncestorContainer.textContent,
      "here is our margin!",
      multiline: true

    #  Little trick here where I assign the variable within console.log
    #  Coffeescript returns the last line of every function, so we send 'send' back
    #  to the caller
    log (send = range.commonAncestorContainer.textContent.slice(left, right))
    send


  #  Coffeescript has constructors!  Let's use them!?
  constructor: (url = null) ->
    sel = document.getSelection()
    log "made it to the try"

    #  Make sure the Range isn't crazy
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

    #  In the future I will use something cooler than window.prompt
    if !url
      url = prompt("give link url", "http://www.awebsite.com")
    if !url?
      return
    log "made it past the try"
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
      log "trying to slice each container"
      @toDB.startText = startStr.slice range.startOffset, startStr.length + 1
      @toDB.endText = endStr.slice 0, range.endOffset
    log "#{@toDB.startText} is startText, #{@toDB.endText} is endText"
    thing = document.createElement('a')
    thing.href = url
    thing.target = '_blank'
    range.surroundContents thing
    $(thing).addClass("signifier")
    $(parent).addClass("signifier")

    Sign.socket.emit "heresASign", @toDB

  @activate: ->
    log "made it to Sign.activate()"
    chrome.extension.sendMessage {greeting: "activated"}, (response) ->
      log "sent activated message to background script!"
      if response.farewell is "runWalkthrough"
        Walkthrough.activate()
    chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
      makeSign = ->
        sign = new Sign()
      removeSign = ->
        Deleter.removeSigsInSel()
      gogglesSign = ->
        sign = new Sign("javascript: (function () { if (window.goggles && window.goggles.active) window.goggles.stop(); else { window.GOGGLE_SERVER='http://goggles.sneakygcr.net/page'; var scr = document.createElement('script'); scr.type = 'text/javascript'; scr.src = 'http://goggles.sneakygcr.net/bookmarklet.js?rand='+Math.random(); document.documentElement.appendChild(scr); } })();")
      do makeSign if request.greeting is "makeSign"
      do removeSign if request.greeting is "removeSign"
      do gogglesSign if request.greeting is "gogglesSign"
#  I got tired of deleting all the database entries by hand each time.
#  CouchDB sucks at mass deleting documents.  Again, if anyone
#  has any tips, shoot me an email!

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
        log "sig attempted to be deleted", a
# chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
#  if request.greeting is "walkthrough"
class Walkthrough
  @activate: () ->
    dialog = $("<div id='sigDialog'>").attr("title", "Welcome to Signifier!").appendTo(document.body)
    $("<p>").html(
      """
      To begin,
      <ol>
      <li>Highlight any text on this page.</li>
      <li>Click the sig button in the upper right hand corner of your browser.</li>
      <li>Click the make sign button</li>
      <li>Copy and paste your url into the dialog box.</li>
      </ol>
      """
    ).appendTo(dialog)
    dialog.dialog()
class SignifierHelpers

  SignifierHelpers.getTextNodes = (elt) ->
    SAT = (node) ->
      if node.nodeType is 3
        return node
      else
        results = [].concat (temp for sn in node.childNodes when (temp = SAT(sn)).length)...
        return results
    SAT elt

  SignifierHelpers.addUpTextLengths = (txtNodeArr) ->
    r = 0
    for a in txtNodeArr
      r += a.textContent.length
    return r

  SignifierHelpers.getTextNodeFromIndex = (arr, num) ->
    r = 0
    i = 0
    ++i while (r+= arr[i].textContent.length) < num
    return arr[i]

  SignifierHelpers.getIndexOfContainingChild = (parent, node) ->
    arr = new Array(parent.childNodes...)
    child = arr[0]
    child = child.nextSibling while !child.contains?(node)
    return child
$ ->
  chrome.extension.sendMessage({signStatus: Signifier.signsFound}, (response) ->
    log response
  )
  Signifier.activate()
  Sign.activate()
  return log "Signifier activated"
