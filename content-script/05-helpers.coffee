class SigHelpers

	SigHelpers.getTextNodes = (elt) ->
		SAT = (node) ->
			if node.nodeType is 3
				return node
			else
				results = [].concat (temp for sn in node.childNodes when (temp = SAT(sn)).length)...
				return results
		SAT elt

	SigHelpers.addUpTextLengths = (txtNodeArr) ->
		r = 0
		for a in txtNodeArr
			r += a.textContent.length
		return r

	SigHelpers.getTextNodeFromIndex = (arr, num) ->
		r = 0
		i = 0
		++i while (r+= arr[i].textContent.length) < num
		return arr[i]

	SigHelpers.getIndexOfContainingChild = (parent, node) ->
		arr = new Array(parent.childNodes...)
		child = arr[0]
		child = child.nextSibling while !child.contains?(node)
		return child
