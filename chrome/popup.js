var makeIt, removeIt;

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

document.getElementById("signer").addEventListener("click", makeIt);

document.getElementById("signer2").addEventListener("click", removeIt);
