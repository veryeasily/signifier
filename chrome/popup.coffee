$("#signer").css
	"background-color": "red"
	top: "5px"
	left: "5px"

$("#signer2").css
	"background-color": "blue"
	top: "100px"
	left: "100px"

makeIt = (e) ->
	chrome.extension.sendRequest {greeting: "makeSign"}, (res) ->
		console.log res

removeIt = (e) ->
	chrome.extension.sendRequest {greeting: "removeSign"}, (res) ->
		console.log res

$("#signer").on "click", makeIt
$("#signer2").on "click", removeIt
