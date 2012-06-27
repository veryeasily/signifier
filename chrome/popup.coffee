#  Wait for document to load by wrapping in jQuery
$ ->
	$("#signer").addClass 'addButton'
	$("#signer2").addClass 'remButton'

	makeIt = (e) ->
		chrome.extension.sendRequest {greeting: "makeSign"}, (res) ->
			console.log res

	removeIt = (e) ->
		chrome.extension.sendRequest {greeting: "removeSign"}, (res) ->
			console.log res

	$("#signer").on "click", makeIt
	$("#signer2").on "click", removeIt
