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

chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
  console.log(sender.tab ? "from content script:" + sender.tab.url : "from the extension");
  console.log("here's the tab info:");
  console.log(sender);
  if (request.signStatus != null) {
    if (request.signStatus === true) {
      return chrome.browserAction.setIcon({
        path: 'images/icon2.png',
        tabId: sender.tab.id
      });
    } else {
      return chrome.browserAction.setIcon({
        path: 'images/icon3.png',
        tabId: sender.tab.id
      });
    }
  }
});
