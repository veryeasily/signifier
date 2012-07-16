		makeCrazy = ->
			# $css.html($css.html() + "\n.rand" + i + " svg {stroke: " + tempy + "; fill: " + tempy + ";}")
			olds = $("div.crazy").animate({ opacity: 0 }, {duration: 100, complete: () -> $(this).remove()})
			a = Math.rand(1, 25)
			temp = Math.rand(3)
			# console.log temp
			# if temp is 2
				# console.log "added even more to a"
				# a+= Math.rand(200)
			for yo in [0...a]
				r = Math.floor(Math.random() * 24) + 1
				tempp = $("<div>").html(window["$thing" + r])
				tempp.addClass("crazy")
				trans = Math.random() * .4 + .15
				tempp.css({
					position: "absolute"
					left: (Math.floor(Math.random() * (window.innerWidth - 200)) + 75) + "px"
					top: (Math.floor(Math.random() * (window.innerHeight - 250)) + 50) + "px"
					opacity: 0
					'z-index': 3
				})
				tmp2 = tempp.children("svg")
				scale = Math.random() + 0.5
				tempy = "#" + getColor() + getColor() + getColor()
				tmp2.css("stroke", tempy).css("fill", tempy)
				# console.log arr2 = tmp2.attr("viewBox").split(" ")
				# tmp2.attr("perserveAspectRatio", "xMinYMin meet")
				# tmp2.attr("viewBox", "0 0 #{arr2[2] * scale} #{arr2[3] * scale}")
				$(document.body).append(tempp)
				tempp.animate({opacity: trans}, {duration: 50})
			window.setTimeout(makeCrazy, Math.rand 400, 1000)

		###
			buttonGo = ->
				$(".but1").animate({backgroundColor: $.Color(saturation: (temp = Math.rand .65, 1, false))}, 100)
				$(".but2").animate({backgroundColor: $.Color(saturation: temp)}, 100)
				$(".but3").animate({backgroundColor: $.Color(saturation: temp)}, 100)
				$(".but4").animate({backgroundColor: $.Color(saturation: temp)}, 100)
				console.log temp
				window.setTimeout(buttonGo, Math.rand 500, 1000)
		###
