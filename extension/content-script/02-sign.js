var Sign;

Sign = (function() {

  Sign.findContainingChild = function(parent, elt) {
    var child, _i, _len, _ref;
    _ref = parent.childNodes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      if (child.contains(elt)) return child;
    }
  };

  Sign.getChildIndex = function(elt) {
    var e, k;
    e = elt;
    k = 0;
    while (e = e.previousSibling) {
      ++k;
    }
    return k;
  };

  Sign.getOffsetToNode = function(parent, elt) {
    var a, child, goddamn, offset;
    if (parent === elt) {
      console.log("returning without reducing");
      return 0;
    } else {
      goddamn = (function() {
        var _i, _len, _ref, _results;
        _ref = parent.childNodes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          _results.push(a);
        }
        return _results;
      })();
      child = Sign.findContainingChild(parent, elt);
      offset = _.foldl(goddamn.slice(0, Sign.getChildIndex(child)), (function(memo, node) {
        return memo + node.textContent.length;
      }), 0);
      if (elt.parentNode !== parent) {
        offset += Sign.getOffsetToNode(Sign.findContainingChild(parent, elt), elt);
      }
      console.log("offset being returned from @getOffsetToNode is: " + offset);
      return offset;
    }
  };

  Sign.socket = Signifier.socket;

  Sign.getMargin = function(range) {
    var endOffset, left, right, send, startOffset;
    console.log("range is =");
    console.log(range);
    startOffset = Sign.getOffsetToNode(range.commonAncestorContainer, range.startContainer) + range.startOffset;
    console.log("startOffset = " + startOffset);
    endOffset = Sign.getOffsetToNode(range.commonAncestorContainer, range.endContainer) + range.endOffset;
    console.log("endOffset = " + endOffset);
    left = Math.max(0, startOffset - 10);
    right = Math.min(range.commonAncestorContainer.textContent.length, endOffset + 10);
    console.log("here is the index of our margin");
    console.log([left, right]);
    console.log("here is range.commonAncestorContainer.textContent");
    console.log(range.commonAncestorContainer.textContent);
    console.log("here is our margin!");
    console.log((send = range.commonAncestorContainer.textContent.slice(left, right)));
    return send;
  };

  function Sign() {
    var end, endStr, parent, range, sel, start, startStr, thing, url, _ref, _ref2, _ref3;
    sel = document.getSelection();
    console.log("made it to the try");
    try {
      if (sel.type !== "Range") {
        alert("no selection!");
        return;
      }
      range = sel.getRangeAt(0);
      if ((parent = this.parent = range.commonAncestorContainer).nodeType === 3) {
        parent = this.parent = parent.parentElement;
      }
      if (range.startContainer.parentElement !== range.endContainer.parentElement) {
        alert("select something simpiler");
        return;
      }
      if ((range.startContainer.nodeType !== 3) || (range.endContainer.nodeType !== 3)) {
        alert("we only can select text to turn to links for right now");
        return;
      }
    } catch (error) {
      throw error;
    }
    url = prompt("give link url", "http://www.awebsite.com");
    console.log("made it past the try");
    _ref = range = sel.getRangeAt(0), start = _ref.startContainer, (_ref2 = _ref.startContainer, startStr = _ref2.textContent), end = _ref.endContainer, (_ref3 = _ref.endContainer, endStr = _ref3.textContent);
    this.toDB = {
      tag: parent.tagName,
      text: range.toString(),
      startText: range.toString(),
      endText: range.toString(),
      margin: Sign.getMargin(range),
      url: url,
      host: document.location.hostname,
      path: document.location.pathname
    };
    if (range.startContainer !== range.endContainer) {
      console.log("trying to slice each container");
      this.toDB.startText = startStr.slice(range.startOffset, startStr.length + 1);
      this.toDB.endText = endStr.slice(0, range.endOffset);
    }
    console.log("" + this.toDB.startText + " is startText, " + this.toDB.endText + " is endText");
    thing = document.createElement('a');
    thing.href = url;
    thing.target = '_blank';
    range.surroundContents(thing);
    $(thing).addClass("signifier").addClass("siggg");
    $(parent).addClass("siggg");
    Sign.socket.emit("heresASign", this.toDB);
  }

  Sign.activate = function() {
    chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
      var makeSign;
      makeSign = function() {
        var sign;
        return sign = new Sign();
      };
      if (request.greeting === "makeSign") return makeSign();
    });
    return chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
      var removeSign;
      removeSign = function() {
        return Deleter.removeSigsInSel();
      };
      if (request.greeting === "removeSign") return removeSign();
    });
  };

  return Sign;

}).call(this);
