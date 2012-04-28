(function() {
  var grapheme_on;

  grapheme_on = false;

  chrome.browserAction.onClicked.addListener(function(tab) {
    return chrome.tabs.sendRequest(tab.id, true, function(response) {});
  });

}).call(this);
