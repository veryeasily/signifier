var Database, Signifier;

$.couch.urlPrefix = "http://127.0.0.1:5984";

Database = (function() {

  function Database() {
    this.site = document.location;
    this.couch = $.couch.db('signifier');
  }

  Database.prototype.getLinks = function() {
    this.couch.view('signifier/links', {
      success: function(data) {
        console.log('data recieved from getLinks: !');
        console.log(data);
        Signifier.checkForSignifier(data);
        return;
      },
      error: function(err) {
        console.log('error!');
        console.log(err);
        return;
      },
      key: [this.site.hostname, this.site.pathname]
    });
  };

  return Database;

})();

Signifier = (function() {

  function Signifier(hostname, pathname) {
    this.doc = document.documentElement;
    this.html = this.doc.innerHTML;
    this.db = new Database();
  }

  Signifier.doc = document.documentElement;

  Signifier.html = Signifier.doc.innerHTML;

  Signifier.db = new Database();

  Signifier.checkForSignifier = function(data) {
    var content, count, workingLinks;
    console.log('made it into checkForSignifier! here is the data argument:');
    console.log(data);
    count = 0;
    workingLinks = [];
    workingLinks = (function() {
      var _i, _len, _ref, _results;
      _ref = data.rows;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        content = _ref[_i];
        console.log('here is a row of our data from the initial:');
        console.log(content);
        if (window.find(content.value, false, false, true)) {
          console.log('found on page: ');
          console.log(content.value);
          _results.push(content.id);
        } else {
          _results.push(null);
        }
      }
      return _results;
    })();
    workingLinks = workingLinks.filter(function(elt) {
      return elt != null;
    });
    return this.grabLinkData(workingLinks);
  };

  Signifier.grabLinkData = function(arr) {
    var count, linkID, linkList, _i, _len, _results,
      _this = this;
    linkList = [];
    count = 0;
    _results = [];
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      linkID = arr[_i];
      _results.push(this.db.couch.openDoc(linkID, {
        success: function(dat) {
          linkList.push(dat);
          count++;
          if (count === arr.length) _this.getTextLocation(linkList);
          return null;
        },
        error: function(err) {
          console.log('Error getting full link from DB!:');
          console.log(err);
          return null;
        }
      }));
    }
    return _results;
  };

  Signifier.selectionIsValid = function() {
    var range, select;
    select = getSelection();
    range = select.getRangeAt(0);
    console.log('range.toString!: ');
    console.log(range.toString().length);
    if (select.anchorNode === select.focusNode && range.toString().length !== 0) {
      return range;
    } else {
      return null;
    }
  };

  Signifier.getTextLocation = function(arr) {
    var end, link, marginLoc, start, textLoc, _i, _len;
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      link = arr[_i];
      this.html = this.doc.innerHTML;
      marginLoc = this.html.indexOf(link.margins);
      start = this.html.indexOf(link.text, marginLoc);
      end = start + link.text.length;
      console.log('made it through get TextLocation with textLoc = ');
      console.log([start, end]);
      textLoc = [start, end];
      this.insertLinks(textLoc, link);
    }
    return textLoc;
  };

  Signifier.insertLinks = function(loc, data) {
    var _this = this;
    document.documentElement.innerHTML = this.html.slice(0, loc[0]) + ("<a href='" + data.link + "'>") + data.text + "</a>" + this.html.slice(loc[1], this.html.length);
    return $(document.body).mousedown(function(ev) {
      console.log('screen clicked!  this was set within Signifier.  mouse button is:');
      console.log(ev.which);
      if (ev.which === 3) return _this.makeLink(ev);
    });
  };

  Signifier.makeLink = function(ev) {
    var data, link, linkedSite, range;
    console.log('made it into makeLink!');
    if (((range = Signifier.selectionIsValid()) != null) !== true) return;
    linkedSite = (linkedSite = prompt('enter hyperlink address', 'http://www.awebsite.com')).substr(0, 4) === 'http' ? linkedSite : linkedSite = 'http://' + linkedSite;
    link = document.createElement('a');
    console.log('here is linkedSite! :');
    console.log(linkedSite);
    data = {
      text: range.toString(),
      loc: new Object(null),
      hostname: this.db.site.hostname,
      pathname: this.db.site.pathname,
      link: (link.href = linkedSite),
      margins: this._getMargins(range).toString()
    };
    range.surroundContents(link);
    /*
    			log the data to upload to DB if necessary
    			console.log data
    */
    return this.db.couch.saveDoc(data, {
      success: function(res) {
        /*
        					console.log "success!"
        					console.log res
        */
      },
      error: function(err) {
        /*
        					console.log "error!"
        					console.log err
        */
      }
    });
  };

  Signifier.prototype.makeLink = Signifier.makeLink;

  Signifier._getMargins = function(range) {
    var lMargin, marginRange, rMargin, shLMargin, shRMargin;
    lMargin = (shLMargin = range.startOffset - 20) >= 0 ? shLMargin : 0;
    rMargin = (shRMargin = range.endOffset + 20) <= range.endContainer.length ? shRMargin : range.endContainer.length;
    marginRange = range.cloneRange();
    marginRange.setStart(range.startContainer, lMargin);
    marginRange.setEnd(range.endContainer, rMargin);
    return marginRange;
  };

  Signifier.prototype._getMargins = Signifier._getMargins;

  return Signifier;

})();

$(function() {
  var signifier, site;
  site = document.location;
  signifier = new Signifier(site.hostname, site.pathname);
  /*
  
  	WARNING!! :
  	-----------------------------------------------------------
  	USE THIS METHOD TO DELETE ALL THE DOCUMENTS ON THE DATABASE
  	-----------------------------------------------------------
  
  	signifier.db.couch.allDocs
  		success: (data) ->
  			console.log 'allDocs query loaded!:'
  			console.log data
  			for doc in data.rows
  				if doc.id.substr(0,4) isnt '_des'
  					dx =
  						_id: doc.id
  					dx._rev = doc.value.rev if doc.value.rev?
  					signifier.db.couch.removeDoc dx,
  						success: (info) ->
  							console.log 'document removed'
  							console.log info
  							null
  						error: (err) ->
  							console.log 'some type of error!:'
  							console.log err
  							null
  				null
  		error: (err) ->
  			console.log 'error querying db for allDocs!:'
  			console.log err
  */
  console.log('here is what our Signifier object looks like: ');
  console.log(signifier);
  window.setTimeout(function() {
    return signifier.db.getLinks();
  }, 2000);
  return $(document.body).mousedown(function(ev) {
    console.log('screen clicked!  mouse button is:');
    console.log(ev.which);
    if (ev.which === 3) return signifier.makeLink(ev);
  });
});
