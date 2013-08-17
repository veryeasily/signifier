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
