var makeIt, removeIt;

$("#signer").css({
  "background-color": "red",
  top: "5px",
  left: "5px"
});

$("#signer2").css({
  "background-color": "blue",
  top: "100px",
  left: "100px"
});

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
