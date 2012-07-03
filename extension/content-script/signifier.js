var Deleter, Sign, Signifier, SignifierHelpers, logging;

logging = true;

Signifier = (function() {

  function Signifier() {}

  Signifier.loc = window.location;

  Signifier.signsFound = false;

  Signifier.alreadySent = false;

  Signifier.deleteEntireDatabase = function() {
    return Signifier.socket.emit('deleteTheWholeShebang');
  };

  Signifier.findTextNode = function(str, node) {
    var child, _i, _len, _ref;
    _ref = node.childNodes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      if ((child.textContent || "").indexOf(str) > -1) {
        if (child.nodeType === 3) {
          if (logging) console.log(child);
          return [child, child.data.indexOf(str)];
        } else if (child.nodeType === 1) {
          if (logging) console.log("dove a level deeper with findTextNode");
          this.findTextNode(str, child);
        }
      }
    }
  };

  Signifier.getNeighborhood = function() {
    this.socket.emit('chillinAt', {
      host: this.loc.hostname,
      path: this.loc.pathname
    });
    return this.socket.on('heresYourHood', function(links) {
      var observer;
      if (logging) {
        console.log("response from heresYourHood!");
        console.log(links);
      }
      Signifier.queWorkingLinks(links);
      observer = new WebKitMutationObserver(function(mutations) {
        var mutation, node, possibleElts, testNodeForSiggg, _i, _j, _k, _len, _len2, _len3, _ref, _results;
        if (logging) console.log(mutations);
        window.mutations = mutations;
        possibleElts = [];
        testNodeForSiggg = function(node) {
          var ref;
          if (!(ref = $(node))) {
            if (logging) {
              console.log("somehow found a node which gives an undefined jQuery object!  here's the node: ");
              console.log(node);
            }
            return true;
          }
          if (node.nodeType = 3) node = node.parentElement && (ref = $(node));
          return ref.hasClass("siggg");
        };
        for (_i = 0, _len = mutations.length; _i < _len; _i++) {
          mutation = mutations[_i];
          if (mutation.addedNodes.length) {
            _ref = mutation.addedNodes;
            for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
              node = _ref[_j];
              if (testNodeForSiggg(node) !== true) {
                if (node.nodeType === 1) {
                  possibleElts.push(node);
                } else if (node.nodeType === 3) {
                  possibleElts.push(node.parentElement);
                }
              }
            }
          }
        }
        if (logging) {
          console.log("Here are the possibleElts of our mutations: ");
          console.log(possibleElts);
        }
        _results = [];
        for (_k = 0, _len3 = possibleElts.length; _k < _len3; _k++) {
          node = possibleElts[_k];
          if (node.textContent !== "") {
            _results.push(Signifier.queWorkingLinks(links, node));
          }
        }
        return _results;
      });
      return observer.observe(document.body, {
        childList: true,
        subtree: true
      });
    });
  };

  Signifier.queWorkingLinks = function(links, parent) {
    var a, link, _i, _len, _ref, _results;
    if (parent == null) parent = document.body;
    Signifier.fillInSign = function(link, parent) {
      var actual, possibles;
      if (parent == null) parent = document.body;
      if (logging) {
        console.log("this is the link ->");
        console.log(link);
      }
      actual = (possibles = $(parent).find("" + link.tag + ":contains(" + link.margin + ")")).filter(function(ind) {
        return Signifier.elementIsSmallest(this, possibles) && $(this).hasClass("siggg") !== true;
      });
      if (logging) {
        console.log("this is the possibles");
        console.log(possibles);
        console.log("this is the actuals: ");
        console.log(actual);
      }
      actual.each(function(ind) {
        var endInfo, range, startInfo, wrapper;
        startInfo = Signifier.findTextNode(link.startText || link.text, this);
        endInfo = Signifier.findTextNode(link.endText || link.text, this);
        range = document.createRange();
        if (logging) {
          console.log("here is our link info");
          console.log(startInfo);
          console.log(endInfo);
        }
        range.setStart(startInfo[0], startInfo[1]);
        range.setEnd(endInfo[0], endInfo[1] + (link.endText || link.text).length);
        wrapper = document.createElement('a');
        wrapper.href = link.url;
        wrapper.target = '_blank';
        range.surroundContents(wrapper);
        $(wrapper).addClass('signifier').addClass('siggg').data('sigId', link._id).data('sigRev', link._rev);
        $(this).addClass("siggg");
        if (Signifier.alreadySent !== true) {
          return chrome.extension.sendMessage({
            signStatus: (Signifier.signsFound = true)
          }, function(response) {
            Signifier.alreadySent = true;
            return console.log(response);
          });
        }
      });
      return actual;
    };
    if (Array.isArray(links.rows)) {
      _ref = links.rows;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        a = _ref[_i];
        if (!(parent.textContent.indexOf(a.value.margin) !== -1)) continue;
        link = a.value;
        _results.push(Signifier.fillInSign(link, parent));
      }
      return _results;
    }
  };

  Signifier.elementIsSmallest = function(elt, arr) {
    var temp, _i, _len;
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      temp = arr[_i];
      if (temp !== elt) if (elt.contains(temp)) return false;
    }
    return true;
  };

  Signifier.activate = function() {
    if (logging) console.log('made it to Signifier.activate()!');
    Signifier.socket = io.connect("http://www.sgnfier.com:7000");
    Sign.socket = Signifier.socket;
    return Signifier.socket.on('whereYat', function(data) {
      if (logging) console.log("whereYat recieved!");
      return Signifier.getNeighborhood();
    });
  };

  return Signifier;

}).call(this);

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
      if (logging) console.log("returning without reducing");
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
      if (logging) {
        console.log("offset being returned from @getOffsetToNode is: " + offset);
      }
      return offset;
    }
  };

  Sign.getMargin = function(range) {
    var endOffset, left, right, send, startOffset;
    if (logging) {
      console.log("range is =");
      console.log(range);
    }
    startOffset = Sign.getOffsetToNode(range.commonAncestorContainer, range.startContainer) + range.startOffset;
    if (logging) console.log("startOffset = " + startOffset);
    endOffset = Sign.getOffsetToNode(range.commonAncestorContainer, range.endContainer) + range.endOffset;
    if (logging) console.log("endOffset = " + endOffset);
    left = Math.max(0, startOffset - 10);
    right = Math.min(range.commonAncestorContainer.textContent.length, endOffset + 10);
    if (logging) {
      console.log("here is the index of our margin");
      console.log([left, right]);
      console.log("here is range.commonAncestorContainer.textContent");
      console.log(range.commonAncestorContainer.textContent);
      console.log("here is our margin!");
    }
    if (logging) {
      console.log((send = range.commonAncestorContainer.textContent.slice(left, right)));
    }
    return send;
  };

  function Sign() {
    var end, endStr, parent, range, sel, start, startStr, thing, url, _ref, _ref2, _ref3;
    sel = document.getSelection();
    if (logging) console.log("made it to the try");
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
    if (logging) console.log("made it past the try");
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
    if (logging) {
      console.log("" + this.toDB.startText + " is startText, " + this.toDB.endText + " is endText");
    }
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

Deleter = (function() {

  function Deleter() {}

  Deleter.removeSigsInSel = function() {
    var a, b, id, parent, range, rev, sel, _i, _len, _ref, _results;
    sel = document.getSelection();
    range = sel.getRangeAt(0);
    parent = range.commonAncestorContainer;
    _ref = $(parent).find("a.siggg");
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      a = _ref[_i];
      if (sel.containsNode(a)) {
        id = $(a).data('sigId');
        rev = $(a).data('sigRev');
        b = a.childNodes[0];
        $(b).unwrap();
        Signifier.socket.emit('delete', {
          id: id,
          rev: rev
        });
        if (logging) {
          console.log("sig attempted to be deleted");
          _results.push(console.log(a));
        } else {
          _results.push(void 0);
        }
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  return Deleter;

})();

$(function() {
  chrome.extension.sendMessage({
    signStatus: Signifier.signsFound
  }, function(response) {
    if (logging) return console.log(response);
  });
  Signifier.activate();
  Sign.activate();
  if (logging) return console.log("Signifier activated");
});

SignifierHelpers = (function() {

  function SignifierHelpers() {}

  SignifierHelpers.getTextNodes = function(elt) {
    var SAT;
    SAT = function(node) {
      var results, sn, temp, _ref;
      if (node.nodeType === 3) {
        return node;
      } else {
        results = (_ref = []).concat.apply(_ref, (function() {
          var _i, _len, _ref, _results;
          _ref = node.childNodes;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            sn = _ref[_i];
            if ((temp = SAT(sn)).length) _results.push(temp);
          }
          return _results;
        })());
        return results;
      }
    };
    return SAT(elt);
  };

  SignifierHelpers.addUpTextLengths = function(txtNodeArr) {
    var a, r, _i, _len;
    r = 0;
    for (_i = 0, _len = txtNodeArr.length; _i < _len; _i++) {
      a = txtNodeArr[_i];
      r += a.textContent.length;
    }
    return r;
  };

  SignifierHelpers.getTextNodeFromIndex = function(arr, num) {
    var i, r;
    r = 0;
    i = 0;
    while ((r += arr[i].textContent.length) < num) {
      ++i;
    }
    return arr[i];
  };

  SignifierHelpers.getIndexOfContainingChild = function(parent, node) {
    var arr, child;
    arr = (function(func, args, ctor) {
      ctor.prototype = func.prototype;
      var child = new ctor, result = func.apply(child, args);
      return typeof result === "object" ? result : child;
    })(Array, parent.childNodes, function() {});
    child = arr[0];
    while (!(typeof child.contains === "function" ? child.contains(node) : void 0)) {
      child = child.nextSibling;
    }
    return child;
  };

  return SignifierHelpers;

})();
