
$(function() {
  var makeIt, removeIt;
  $("#signer").addClass("sigButton").addClass("addButton");
  $("#signer2").addClass("sigButton").addClass("delButton");
  $("#text1").addClass("sigButton").addClass("addButton").addClass("inside");
  $("#text2").addClass("sigButton").addClass("delButton").addClass("inside");
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
