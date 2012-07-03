
$(function() {
  var $thing, a, getColor, inty, obj, param1, param2, rand, temp, _results;
  getColor = function() {
    return (Math.floor(Math.random() * 16)).toString(16)(+(Math.floor(Math.random() * 16)).toString(16));
  };
  rand = Math.floor(Math.random() * 20) + 1;
  _results = [];
  for (a = 0; 0 <= rand ? a < rand : a > rand; 0 <= rand ? a++ : a--) {
    $thing = $("<div>").css({
      position: absolute,
      left: Math.floor(Math.random() * 600) + "px",
      top: Math.floor(Math.random() * 400) + "px"
    });
    inty = Math.floor(Math.random() * 9) + 1;
    obj = document.createElement("object");
    obj.data = "svg/" + inty + ".svg";
    obj.type = "image/svg+xml";
    param1 = document.createElement("param");
    param2 = document.createElement("param");
    param1.name = "stroke";
    param2.name = "fill";
    param1.value = (temp = "#" + getColor() + getColor() + getColor());
    param2.value = temp;
    obj.appendChild(param1);
    obj.appendChild(param2);
    $thing[0].appendChild(obj);
    _results.push(document.body.appendChild($thing[0]));
  }
  return _results;
});
