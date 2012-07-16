#  Wait for document to load by wrapping in jQuery
$ ->
	go = () ->
		$(document.body).height(48)
	setTimeout(go, 20)

	makeIt = (e) ->
		chrome.extension.sendRequest {greeting: "makeSign"}, (res) ->
			console.log res

	removeIt = (e) ->
		chrome.extension.sendRequest {greeting: "removeSign"}, (res) ->
			console.log res

	$("#signer").on("click", makeIt)
	$("#signer2").on("click", removeIt)
	$("#signer3").on("click", ->)
