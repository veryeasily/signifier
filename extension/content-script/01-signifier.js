var Signifier, logging;

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
    Signifier.socket = io.connect("http://127.0.0.1:7000");
    Sign.socket = Signifier.socket;
    return Signifier.socket.on('whereYat', function(data) {
      if (logging) console.log("whereYat recieved!");
      return Signifier.getNeighborhood();
    });
  };

  return Signifier;

}).call(this);
