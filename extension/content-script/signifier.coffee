LOGGING = true
# DEVELOPMENT SERVER
# SOCKET_ADDRESS = "http://127.0.0.1:7000"

# PRODUCTION SERVER
SOCKET_ADDRESS = "http://larry.chatlands.com:7000"

#   ToDo: Direct connections with facebook and twitter
#     to lower database load.

class Signifier
  @loc: window.location

  @signsFound: false

  @alreadySent: false

  @deleteEntireDatabase: =>
    @socket.emit 'deleteTheWholeShebang'

  @findTextNode: (str, node) ->
    for child in node.childNodes when (child.textContent || "").indexOf(str) > -1
      if child.nodeType is 3
        if LOGGING then console.log child
        return [child, child.data.indexOf(str)]
      else if child.nodeType is 1
        console.log "dove a level deeper with findTextNode" if LOGGING
        return @findTextNode str, child

  @getNeighborhood: ->
    @socket.emit 'chillinAt',
      host: @loc.hostname,
      path: @loc.pathname
    @socket.on 'heresYourHood', (links) ->
      if LOGGING
        console.log "response from heresYourHood!"
        console.log links
      Signifier.queWorkingLinks links


    #  This uses the WebKitMutationObserver object to figure out when
    #  dynamic content is added to the page. MutationObservers are
    #  incredibly general objects, so we have to do a lot of parsing
    #  through the data.
    observer = new WebKitMutationObserver (mutations) ->
      possibleElts = []

      #  Sometimes the "when" part of loop comprehensions can
      #  get a little crazy, so the code gets moved to its
      #  own function.
      testNodeForSiggg = (node) ->
        if !(ref = $ node)
          if LOGGING
            console.log "somehow found a node which gives an undefined
              jQuery object!  here's the node: "
            console.log node
          return true

        # If it's a text node, we're done! Back to the parent.
        if node.nodeType = 3
          node = node.parentElement and ref = $ node
        return ref.hasClass("siggg")

        console.log mutations if LOGGING
        window.mutations = mutations

        # Function which checks if node is already a signifier. We require
        # the node to be a html element, so we climb up from text nodes
        # if necessary.
        for mutation in mutations when mutation.addedNodes.length
          for node in mutation.addedNodes when testNodeForSiggg(node) isnt true
            if node.nodeType is 1 then possibleElts.push node
            else if node.nodeType is 3 then possibleElts.push node.parentElement

        if LOGGING
          console.log "Here are the possibleElts of our mutations: "
          console.log possibleElts
        for node in possibleElts when node.textContent isnt ""
          Signifier.queWorkingLinks(links, node)

      observer.observe(document.body, {childList: true, subtree: true})
            
  # Given a parent element, iterates over a list of links from couchDB
  # looking for matching margin text. Once margin text is found, fill
  # in the link if we need to add one.
  @queWorkingLinks: (links, parent = document.body) ->

    Signifier.fillInSign = (link, parent = document.body) ->
      if LOGGING
        console.log "this is the link ->"
        console.log link
      possibles = ($ parent).find "#{link.tag}:contains(#{link.margin})"
      actual = possibles.filter (ind) ->
        (Signifier.elementIsSmallest @, possibles) and ($(this).hasClass "siggg") isnt true
      if LOGGING
        console.log "this is the possibles"
        console.log possibles
        console.log "this is the actuals: "
        console.log actual
      actual.each (ind) ->
        range = document.createRange()
        startInfo = Signifier.findTextNode(link.startText || link.text, this)
        endInfo = Signifier.findTextNode(link.endText || link.text, this)
        if LOGGING
          console.log "here is our link info"
          console.log startInfo
          console.log endInfo
        range.setStart(
          startInfo[0],
          startInfo[1]
        )
        range.setEnd(
          endInfo[0],
          endInfo[1] + (link.endText || link.text).length
        )
        #  Now we create our link wrapper to place around with jQuery
        wrapper = document.createElement 'a'
        wrapper.href = link.url
        wrapper.target = '_blank'
        range.surroundContents wrapper
        $(wrapper).addClass('signifier')
          .addClass('siggg')
          .data('sigId', link._id)
          .data('sigRev', link._rev)
        $(this).addClass("siggg")
        if Signifier.alreadySent isnt true
          chrome.extension.sendMessage signStatus: (Signifier.signsFound = true),
            (response) ->
              Signifier.alreadySent = true
              console.log response if LOGGING
      return actual

    if Array.isArray links.rows
      for a in links.rows when (
        (parent.textContent.indexOf a.value.margin) isnt -1)
        link = a.value
        Signifier.fillInSign link, parent

  @elementIsSmallest: (elt, arr) ->
    for temp in arr when temp isnt elt
      if elt.contains(temp)
        return false
    return true


  @activate: ->
    console.log 'made it to Signifier.activate()!' if LOGGING

    # Legit version
    Signifier.socket = io.connect SOCKET_ADDRESS

    Sign.socket = Signifier.socket
    Signifier.socket.on 'whereYat', (data) ->
      console.log "whereYat recieved!" if LOGGING
      Signifier.getNeighborhood()
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
      console.log "returning without reducing" if LOGGING
      return 0
    else
      goddamn = (a for a in parent.childNodes)
      child = @findContainingChild(parent, elt)
      offset = _.foldl goddamn[0...@getChildIndex child], ((memo, node) -> memo + node.textContent.length), 0
      #  ^^ This is the only time I use underscore.js in the extension?
      if elt.parentNode isnt parent
        offset+= @getOffsetToNode(@findContainingChild(parent, elt), elt)
      console.log "offset being returned from @getOffsetToNode is: #{offset}" if LOGGING
      return offset

  @getMargin: (range) =>
    if LOGGING
      console.log "range is ="
      console.log range

    #  Calculates the offset through ALL child nodes of the CAC to range.startContainer (a text node)
    startOffset = @getOffsetToNode(range.commonAncestorContainer, range.startContainer) + range.startOffset
    console.log "startOffset = #{startOffset}" if LOGGING


    #  Same deal here but with range.endContainer
    endOffset = @getOffsetToNode(range.commonAncestorContainer, range.endContainer) + range.endOffset
    console.log "endOffset = #{endOffset}" if LOGGING


    #  Grab 10 letters to the left and right of the selection unless we're out of room
    left = Math.max(0, startOffset - 10)
    right = Math.min(range.commonAncestorContainer.textContent.length, endOffset + 10)
    if LOGGING
      console.log "here is the index of our margin"
      console.log [left, right]
      console.log "here is range.commonAncestorContainer.textContent"
      console.log range.commonAncestorContainer.textContent
      console.log "here is our margin!"

    #  Little trick here where I assign the variable within console.log
    #  Coffeescript returns the last line of every function, so we send 'send' back
    #  to the caller
    console.log (send = range.commonAncestorContainer.textContent.slice(left, right)) if LOGGING
    send


  #  Coffeescript has constructors!  Let's use them!?
  constructor: (url = null) ->
    sel = document.getSelection()
    console.log "made it to the try" if LOGGING

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
    console.log "made it past the try" if LOGGING
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
      console.log "trying to slice each container"
      @toDB.startText = startStr.slice range.startOffset, startStr.length + 1
      @toDB.endText = endStr.slice 0, range.endOffset
    console.log "#{@toDB.startText} is startText, #{@toDB.endText} is endText" if LOGGING
    thing = document.createElement('a')
    thing.href = url
    thing.target = '_blank'
    range.surroundContents thing
    $(thing).addClass("signifier")
        .addClass("siggg")
    $(parent).addClass("siggg")

    Sign.socket.emit "heresASign", @toDB

  @activate: ->
    console.log "made it to Sign.activate()"
    chrome.extension.sendMessage {greeting: "activated"}, (response) ->
      console.log "sent activated message to background script!"
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
        if LOGGING
          console.log "sig attempted to be deleted"
          console.log a
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
    console.log response if LOGGING
  )
  Signifier.activate()
  Sign.activate()
  if LOGGING
    return console.log "Signifier activated"
