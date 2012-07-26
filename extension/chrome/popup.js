var trigger;

trigger = false;

$(function() {
  var gogglesIt, makeIt, moreStuff, removeIt;
  $(document.body).show(300);
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
  gogglesIt = function(e) {
    console.log("made it to gogglesIt!");
    return chrome.extension.sendRequest({
      greeting: "gogglesSign"
    }, function(res) {
      return console.log(res);
    });
  };
  moreStuff = function(e) {
    var divy, holder, temp;
    if (!trigger) {
      divy = $("<div></div>").addClass("outer2").hide().appendTo(document.body);
      temp = $("<div class='holder'></div>").appendTo(divy);
      $("<button id='signer4'>goggles</button>").addClass("sigButton").addClass("gogButton").appendTo(temp);
      $("<button id='signer5'>own text</button>").addClass("sigButton").addClass("texButton").appendTo(temp);
      $("#signer4").on("click", gogglesIt);
      $("#signer5").on("click", function() {});
      divy.show("fast");
      return trigger = true;
    } else {
      holder = $(".outer2");
      holder.hide("fast", function() {
        console.log("callback triggered!");
        return $(this).remove();
      });
      return trigger = false;
    }
  };
  $("#signer").on("click", makeIt);
  $("#signer2").on("click", removeIt);
  return $("#signer3").on("click", gogglesIt);
});
