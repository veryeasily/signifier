#  Wait for document to load by wrapping in jQuery
$ ->
	$("#signer").addClass("sigButton").addClass("addButton")
	$("#signer2").addClass("sigButton").addClass("delButton")
	$("#text1").addClass("sigButton").addClass("addButton").addClass("inside")
	$("#text2").addClass("sigButton").addClass("delButton").addClass("inside")

	makeIt = (e) ->
		chrome.extension.sendRequest {greeting: "makeSign"}, (res) ->
			console.log res

	removeIt = (e) ->
		chrome.extension.sendRequest {greeting: "removeSign"}, (res) ->
			console.log res

	$("#signer").on "click", makeIt
	$("#signer2").on "click", removeIt
