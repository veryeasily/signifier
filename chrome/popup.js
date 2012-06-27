
$(function() {
  var makeIt, removeIt;
  $("#signer").addClass('addButton');
  $("#signer2").addClass('remButton');
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
  return $("#signer2").on("click", removeIt);
});
