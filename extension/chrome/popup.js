
$(function() {
  var go, makeIt, removeIt;
  go = function() {
    return $(document.body).height(48);
  };
  setTimeout(go, 20);
  makeIt = function(e) {
    return chrome.extension.sendRequest({
      greeting: "makeSign"
    }, function(res) {
      return console.log(res);
    });
  };
  removeIt = function(e) {
    return chrome.extension.sendRequest({
      greeting: "removeSign"
    }, function(res) {
      return console.log(res);
    });
  };
  $("#signer").on("click", makeIt);
  $("#signer2").on("click", removeIt);
  return $("#signer3").on("click", function() {});
});
