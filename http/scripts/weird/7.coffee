$(
    () ->
        this.$thing7 = $("<div>").css({
                position: "absolute",
                left: (Math.floor(Math.random() * 1100) + "px"),
                top: (Math.floor(Math.random() * 500) + "px"),
            })
        tempy = "#" + getColor() + getColor() + getColor()
		# style="stroke: ' + tempy + '; fill: ' + tempy + ';" 
        this.$thing7.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Layer_1" x="0px" y="0px" width="100px" height="100px" viewBox="-346 256 100 100" enable-background="new -346 256 100 100" xml:space="preserve">
			<path d="M-246.029,288.423h-9.613l-2.025-15.36c0,0-1.025-8.746-2.062-9.846c-1.296-1.374-2.904-1.514-2.904-1.514  c-0.001,0-66.627,0-66.627,0c0,0-1.607,0.14-2.904,1.514c-1.036,1.1-2.063,9.846-2.063,9.846l-2.026,15.36h-9.519v14.902  l7.396,1.186l-0.967,7.331v40.581c0,1.905,1.545,3.454,3.453,3.454h6.285c1.91,0,3.456-1.549,3.456-3.454v-9.602h60.408v9.602  c0,1.905,1.545,3.454,3.453,3.454h6.286c1.908,0,3.453-1.549,3.453-3.454v-40.581l-0.965-7.315l7.487-1.201V288.423z   M-326.204,325.969c-3.351,0-6.066-2.714-6.066-6.065c0-3.35,2.716-6.065,6.066-6.065c3.349,0,6.065,2.716,6.065,6.065  C-320.139,323.255-322.854,325.969-326.204,325.969z M-277.599,325.231h-36.993v-3.983h37.013L-277.599,325.231z M-277.568,318.798  h-37.023v-3.983h37.042L-277.568,318.798z M-265.74,325.969c-3.35,0-6.065-2.714-6.065-6.065c0-3.35,2.716-6.065,6.065-6.065  s6.066,2.716,6.066,6.065C-259.674,323.255-262.391,325.969-265.74,325.969z M-332.823,299.324l2.786-24.683h67.86l3.101,24.683  H-332.823z"/>
			</svg>')
		# $css.html($css.html() + "\n.rand" + i + " svg {stroke: " + tempy + "; fill: " + tempy + ";}")
        $(document.body).append(this.$thing7)
)