
$(function() {
  var getColor, thing;
  getColor = function() {
    var arr, colStr, i, randHex, str3, temp, thing, thingy, x, _len, _step;
    randHex = function() {
      return (Math.floor(Math.random() * 16)).toString(16);
    };
    arr = (function() {
      var _results;
      _results = [];
      for (i = 0; i < 6; i++) {
        _results.push(randHex());
      }
      return _results;
    })();
    colStr = ["#"].concat(arr).join("");
    $(document.body).css({
      color: colStr
    });
    temp = document.body.innerHTML;
    str3 = "here's the nums: ";
    for (i = 0, _len = arr.length, _step = 2; i < _len; i += _step) {
      x = arr[i];
      str3 += parseInt(arr[i] + arr[i + 1], 16) + " ";
    }
    if (temp.indexOf("#") === -1) {
      document.body.innerHTML += "<br />" + colStr + " " + str3;
    } else {
      thingy = document.body.innerHTML = (temp = document.body.innerHTML).slice(0, temp.length - 11) + ("<br />" + colStr) + str3;
    }
    console.log(thingy);
    thing = document.getElementById("sigButton");
    return thing.addEventListener("mousedown", getColor);
  };
  thing = document.getElementById("sigButton");
  return thing.addEventListener("mousedown", getColor);
});
