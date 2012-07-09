var db, db_name, io, nano;

io = require('socket.io').listen(7000);

nano = require('nano')('http://127.0.0.1:5984');

db_name = "signifier";

db = nano.use(db_name);

io.sockets.on('connection', function(socket) {
  var Signifier, address;
  address = socket.handshake.address;
  console.log("here is the address!: ");
  console.log(address);
  Signifier = (function() {

    function Signifier() {}

    Signifier.socket = socket;

    Signifier.scoutHood = function(imAt) {
      console.log("querying db with [host,path] = ");
      console.log([imAt.host, imAt.path]);
      return db.view('signifier', 'neighborhood', {
        key: [imAt.host, imAt.path]
      }, function(err, signs) {
        console.log(signs);
        return Signifier.socket.emit("heresYourHood", signs);
      });
    };

    Signifier.sendSigns = function(signs) {
      return Signifier.socket.emit("heresYourHood", signs);
    };

    Signifier.deleteAllDocs = function() {
      return db.view('signifier', 'neighborhood', function(err, body) {
        var a, doc, _i, _len, _ref;
        if (err) {
          console.log(err);
          return;
        }
        _ref = body.rows;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          doc = a.value;
          db.destroy(doc._id, doc._rev, function(err, body) {
            return console.log(err || body);
          });
        }
        return console.log("database purged successfully!");
      });
    };

    return Signifier;

  })();
  socket.emit('whereYat', {
    header: null
  });
  console.log('whereYat just sent');
  socket.on('chillinAt', function(imAt) {
    return Signifier.scoutHood(imAt);
  });
  socket.on("heresASign", function(sign) {
    sign.creator = {
      ip: socket.handshake.address.address
    };
    return db.insert(sign, function(err, body, headers) {
      if (err === false) return console.log(headers, body);
    });
  });
  socket.on("delete", function(sig) {
    return db.destroy(sig.id, sig.rev, function(err, body) {
      console.log(err);
      console.log(body);
      if (!err) return console.log("sig successfully deleted");
    });
  });
  return socket.on("deleteTheWholeShebang", function() {
    return Signifier.deleteAllDocs();
  });
});
