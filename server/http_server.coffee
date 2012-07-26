http = require('http')

s = http.createServer((req, res) ->
	res.writeHead('200', 'content-type': 'text/plain')
	res.end("hello world\n")
	null
)

s.listen(80)
