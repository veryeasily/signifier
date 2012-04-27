/*
	var grapheme_on = false;

	chrome.browserAction.onClicked.addListener(function(tab) {
		if (grapheme_on == false)
		{
			console.log("grapheme was false");
			chrome.tabs.executeScript(null, {file:"scripts/jquery.min.js"}, function() {
				chrome.tabs.executeScript(null, {file:"scripts/jquery.couch.js"}, function(){
					chrome.tabs.executeScript(null, {file:"inject/grapheme.js"}, function() {
						grapheme_on = true;
					});
				});
			});
		}
		else
		{
			console.log("grapheme was already on?");
			chrome.tabs.sendRequest(tab.id, {'closeGrapheme': true}, function(response) { });
			grapheme_on = false;
		}
	});
*/
