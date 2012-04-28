grapheme_on = false
chrome.browserAction.onClicked.addListener (tab) ->
	chrome.tabs.sendRequest tab.id, true, (response) ->
