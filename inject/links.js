var Database, Signified;

$.couch.urlPrefix = "http://127.0.0.1:5984";

Database = (function() {

  function Database() {
    this.site = document.location;
    this.couch = $.couch.db('signified');
  }

  Database.prototype.getLinks = function() {
    this.couch.view('signified/links', {
      success: function(data) {
        return Signified.checkForSignifier(data);
      },
      error: function(err) {
        console.log('error!');
        return console.log(err);
      },
      key: [this.site.hostname, this.site.pathname]
    });
    return null;
  };

  return Database;

})();

Signified = (function() {

  function Signified(hostname, pathname) {
    this.db = new Database();
    this.doc = document.documentElement;
    this.html = this.doc.innerHTML;
  }

  Signified.checkForSignifier = function(data) {
    var content, _i, _len, _ref, _results,
      _this = this;
    _ref = data.rows;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      content = _ref[_i];
      if (!(find(content.value === true))) continue;
      this.db.couch.openDoc(content.id, {
        success: function(dat) {
          _this.getTextLocation(dat);
          return null;
        },
        error: function(err) {
          console.log('Error getting full link from DB!:');
          console.log(err);
          return null;
        }
      });
      _results.push(content);
    }
    return _results;
  };

  Signified.selectionIsValid = function() {
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

  Signified.prototype.getTextLocation = function(data) {
    var end, marginLoc, start;
    marginLoc = this.html.indexOf(data.margins);
    start = this.html.indexOf(data.text, marginLoc);
    end = start + data.text.length;
    /*
    			console.log 'made it through get TextLocation with textLoc = '
    			console.log [start, end]
    			textLoc = [start, end]
    */
    this.insertLinks(textLoc, data);
    return textLoc;
  };

  Signified.prototype.insertLinks = function(loc, data) {
    document.documentElement.innerHTML = this.html.slice(0, loc[0]) + ("<a href='" + data.link + "'>") + data.text + "</a>" + this.html.slice(loc[1], this.html.length);
    return $(document.body).mousedown(this.makeLink);
  };

  Signified.prototype.makeLink = function(ev) {
    var data, link, linkedSite, range;
    console.log('made it into makeLink!');
    if (((range = Signified.selectionIsValid()) != null) !== true) return;
    linkedSite = (linkedSite = prompt('enter hyperlink address', 'http://www.awebsite.com')).substr(0, 4 === 'http') ? linkedSite : linkedSite = 'http://' + linkedSite;
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

  Signified.prototype._getMargins = function(range) {
    var lMargin, marginRange, rMargin, shLMargin, shRMargin;
    lMargin = (shLMargin = range.startOffset - 20) >= 0 ? shLMargin : 0;
    rMargin = (shRMargin = range.endOffset + 20) <= range.endContainer.length ? shRMargin : range.endContainer.length;
    marginRange = range.cloneRange();
    marginRange.setStart(range.startContainer, lMargin);
    marginRange.setEnd(range.endContainer, rMargin);
    return marginRange;
  };

  return Signified;

})();

$(function() {
  var signified, site;
  site = document.location;
  signified = new Signified(site.hostname, site.pathname);
  console.log('here is what our Signified object looks like: ');
  console.log(signified);
  signified.db.getLinks();
  return $(document.body).mousedown(function(ev) {
    console.log('screen clicked!  mouse button is:');
    console.log(ev.which);
    if (ev.which === 3) return signified.makeLink(ev);
  });
});
