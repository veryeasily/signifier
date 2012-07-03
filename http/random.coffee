$ ->
	getColor = () ->
		randHex = ->
			(Math.floor(Math.random() * 16)).toString(16)
		arr = (do randHex for i in [0...6])
		colStr = ["#"].concat(arr).join("")
		$(document.body).css({color: colStr})
		temp = document.body.innerHTML
		str3 = "here's the nums: "
		(str3 += parseInt(arr[i] + arr[i + 1], 16) + " ") for x, i in arr by 2
		if temp.indexOf("#") is -1
			document.body.innerHTML += "<br />" + colStr + " " + str3
		else (thingy = document.body.innerHTML = (temp = document.body.innerHTML).slice(0, temp.length - 11) + ("<br />" + colStr) + str3)
		console.log thingy
		thing = document.getElementById("sigButton")
		thing.addEventListener("mousedown", getColor)

	thing = document.getElementById("sigButton")
	thing.addEventListener("mousedown", getColor)
