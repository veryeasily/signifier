###
chrome.browserAction.onClicked.addListener (tab) ->
  chrome.tabs.sendRequest tab.id, {greeting: "makeSign"},
	  (response) ->
		  console.log response
###
chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
	if request.greeting
		if request.greeting is "makeSign"
			chrome.tabs.getSelected null, (tab) ->
				chrome.tabs.sendRequest tab.id, {greeting: "makeSign"}, (response) ->
					console.log response
		else if request.greeting is "removeSign"
			chrome.tabs.getSelected null, (tab) ->
				chrome.tabs.sendRequest tab.id, {greeting: "removeSign"}, (response) ->
					console.log response
	else return null
