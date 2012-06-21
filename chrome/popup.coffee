makeIt = (e) ->
	chrome.extension.sendRequest {greeting: "makeSign"}, (res) ->
		console.log res

removeIt = (e) ->
	chrome.extension.sendRequest {greeting: "removeSign"}, (res) ->
		console.log res

document.getElementById("signer").addEventListener("click", makeIt)
document.getElementById("signer2").addEventListener("click", removeIt)
