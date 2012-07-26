var buttonGo, makeCrazy;

makeCrazy = function() {
  var a, olds, r, scale, temp, tempp, tempy, tmp2, trans, yo;
  olds = $("div.crazy").animate({
    opacity: 0
  }, {
    duration: 150,
    complete: function() {
      return $(this).remove();
    }
  });
  a = Math.floor(Math.random() * 7) + 1;
  console.log(temp = Math.rand(3));
  if (temp === 2) {
    console.log("added even more to a");
    a += Math.rand(12);
  }
  for (yo = 0; 0 <= a ? yo < a : yo > a; 0 <= a ? yo++ : yo--) {
    r = Math.floor(Math.random() * 24) + 1;
    tempp = $("<div>").html(window["$thing" + r]);
    tempp.addClass("crazy");
    trans = Math.random() * .4 + .15;
    tempp.css({
      position: "absolute",
      left: (Math.floor(Math.random() * (window.innerWidth - 200)) + 75) + "px",
      top: (Math.floor(Math.random() * (window.innerHeight - 250)) + 50) + "px",
      opacity: 0
    });
    tmp2 = tempp.children("svg");
    scale = Math.random() + 0.5;
    tempy = "#" + getColor() + getColor() + getColor();
    tmp2.css("stroke", tempy).css("fill", tempy);
    $(document.body).append(tempp);
    tempp.animate({
      opacity: trans
    }, {
      duration: 150
    });
  }
  return window.setTimeout(makeCrazy, Math.random() * 400 + 500);
};

buttonGo = function() {
  $(".but1").animate({
    backgroundColor: $.Color({
      saturation: Math.rand(.5, 1, false)
    })
  }, 200);
  $(".but2").animate({
    backgroundColor: $.Color({
      saturation: Math.rand(.5, 1, false)
    })
  }, 200);
  $(".but3").animate({
    backgroundColor: $.Color({
      saturation: Math.rand(.5, 1, false)
    })
  }, 200);
  $(".but4").animate({
    backgroundColor: $.Color({
      saturation: Math.rand(.5, 1, false)
    })
  }, 200);
  return window.setTimeout(buttonGo, Math.random() * 50 + 600);
};
