$(
	() ->
		Math.rand = (num1, num2, floor=true) ->
			if typeof(num2) isnt "number"
				floor = num2 if typeof num2 is "boolean"
				tempnum = Math.random() * num1
			else
				diff = Math.abs num2 - num1
				tempnum = (Math.random() * diff) + num1
			if floor
				tempnum = Math.floor tempnum
			return tempnum
		getColor = () ->
				a = (Math.rand 2, 16).toString(16)
				b = (Math.rand 2, 16).toString(16)
				a + b
		getColor2 = () ->
				a = (Math.rand 9, 13).toString(16)
				b = (Math.rand 9, 13).toString(16)
				a + b
		getColor3 = () ->
				a = (Math.rand 2).toString(16)
				b = (Math.rand 2).toString(16)
				a + b
		getColor4 = () ->
				a = (Math.rand 4, 6).toString(16)
				b = (Math.rand 4, 6).toString(16)
				a + b
		getColor5 = () ->
				a = (Math.rand 7, 11).toString(16)
				b = (Math.rand 7, 11).toString(16)
				a + b
		tempy = "#" + getColor() + getColor() + getColor()
