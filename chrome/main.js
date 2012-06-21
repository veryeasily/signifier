/*
chrome.browserAction.onClicked.addListener (tab) ->
  chrome.tabs.sendRequest tab.id, {greeting: "makeSign"},
	  (response) ->
		  console.log response
*/
chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
  if (request.greeting) {
    if (request.greeting === "makeSign") {
      return chrome.tabs.getSelected(null, function(tab) {
        return chrome.tabs.sendRequest(tab.id, {
          greeting: "makeSign"
        }, function(response) {
          return console.log(response);
        });
      });
    } else if (request.greeting === "removeSign") {
      return chrome.tabs.getSelected(null, function(tab) {
        return chrome.tabs.sendRequest(tab.id, {
          greeting: "removeSign"
        }, function(response) {
          return console.log(response);
        });
      });
    }
  } else {
    return null;
  }
});
