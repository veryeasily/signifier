		makeCrazy = ->
			# $css.html($css.html() + "\n.rand" + i + " svg {stroke: " + tempy + "; fill: " + tempy + ";}")
			$("div.crazy").remove()
			a = Math.floor(Math.random() * 7) + 1
			console.log temp = Math.rand(3)
			if temp is 2
				console.log "added even more to a"
				a+= Math.rand(12)
			for yo in [0...a]
				r = Math.floor(Math.random() * 24) + 1
				tempp = $("<div>").html(window["$thing" + r])
				tempp.addClass("crazy")
				trans = Math.random() * .4 + .15
				tempp.css({
					position: "absolute"
					left: (Math.floor(Math.random() * (window.innerWidth - 200)) + 75) + "px"
					top: (Math.floor(Math.random() * (window.innerHeight - 250)) + 50) + "px"
					opacity: trans
				})
				tmp2 = tempp.children("svg")
				scale = Math.random() + 0.5
				tempy = "#" + getColor() + getColor() + getColor()
				tmp2.css("stroke", tempy).css("fill", tempy)
				# console.log arr2 = tmp2.attr("viewBox").split(" ")
				# tmp2.attr("perserveAspectRatio", "xMinYMin meet")
				# tmp2.attr("viewBox", "0 0 #{arr2[2] * scale} #{arr2[3] * scale}")
				$(document.body).append(tempp)
			window.setTimeout(makeCrazy, Math.random() * 500 + 400)

		buttonGo = ->
			$(".but1").css({"background-color": "#" + getColor3() + getColor3() + getColor2()})
			$(".but2").css({"background-color": "#" + getColor3() + getColor5() + getColor3()})
			$(".but3").css({"background-color": "#" + (temp = getColor5()) + temp + getColor3()})
			$(".but4").css({"background-color": "#" + getColor2() + getColor3() + getColor3()})
			window.setTimeout(buttonGo, Math.random() * 50 + 600)
