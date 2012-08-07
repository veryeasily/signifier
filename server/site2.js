var express = require('express');

var app = express.createServer();

var fs = require('fs');

app.configure('development', function() {
	app.use(express.logger());
	app.use(express.errorHandler({
		dumpExceptions: true,
		showStack: true
	}));
});

app.configure('production', function() {
	app.use(express.logger());
	app.use(express.errorHandler());
});

app.use(express.static(__dirname + '/public'));

/*
 * app.use('/css', express.static(__dirname + '/css'));
 * app.use('/scripts', express.static(__dirname + '/scripts'));
 * app.use('/images', express.static(__dirname + '/images'));
 * app.set('views', __dirname + '/views');
 * app.set('view engine', 'jade');
 * app.set('view options', {layout: false});
*/

// app.register('.html', require('jade'));

fs.readFile('./public/sig.html', function (err, html) {
	app.get('/', function(req, res){
		res.sendfile(__dirname + html)
	});
});


app.listen(80, 'www.sgnfier.com');
