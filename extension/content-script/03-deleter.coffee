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
