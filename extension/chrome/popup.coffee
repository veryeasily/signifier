#  Wait for document to load by wrapping in jQuery
trigger = false
$ ->
	$(document.body).show(300)
	(firstButton = $("#signer")).addClass("sigSelect")
	allButtons = $(".sigButton")
	$(".sigButton").on("mouseover", () ->
		allButtons.removeClass("sigSelect")
		$(this).addClass("sigSelect")
	)

	makeIt = (e) ->
		$(this).addClass("sigSelect")
		chrome.extension.sendRequest {greeting: "makeSign"}, (res) ->
			console.log res

	removeIt = (e) ->
		$(this).addClass("sigSelect")
		chrome.extension.sendRequest {greeting: "removeSign"}, (res) ->
			console.log res

	gogglesIt = (e) ->
		$(this).addClass("sigSelect")
		console.log "made it to gogglesIt!"
		chrome.extension.sendRequest {greeting: "gogglesSign"}, (res) ->
			console.log res


	moreStuff = (e) ->


		if !trigger
			divy = $("<div></div>").addClass("outer2").hide().appendTo(document.body)
			temp = $("<div class='holder'></div>").appendTo(divy)
			$("<button id='signer4'>goggles</button>").addClass("sigButton").addClass("gogButton").appendTo(temp)
			$("<button id='signer5'>own text</button>").addClass("sigButton").addClass("texButton").appendTo(temp)
			$("#signer4").on("click", gogglesIt)
			$("#signer5").on("click", ->)
			divy.show("fast")
			trigger = true
		else
			holder = $(".outer2")
			holder.hide("fast", () ->
				console.log "callback triggered!"
				$(this).remove()
			)
			trigger = false

	$("#signer").on("click", makeIt)
	$("#signer2").on("click", removeIt)
	$("#signer3").on("click", gogglesIt)
