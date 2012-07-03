$(
	() ->
		makeCrazy = ->
			this.$thing1 = $("<div>")
			this.$thing2 = $("<div>")
			this.$thing3 = $("<div>")
			this.$thing4 = $("<div>")
			this.$thing5 = $("<div>")
			this.$thing6 = $("<div>")
			this.$thing7 = $("<div>")
			this.$thing8 = $("<div>")
			this.$thing9 = $("<div>")
			getColor = () ->
					a = (Math.floor(Math.random() * 14) + 2).toString(16)
					b = (Math.floor(Math.random() * 14) + 2).toString(16)
					a + b
			tempy = "#" + getColor() + getColor() + getColor()
			this.$thing1.html('<svg version="1.0" id="Layer_1" xmlns="http://www.w3.org/2000/svg" style="stroke: ' + tempy + '; fill: ' +
				tempy + ';" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
				   width="98.455px" height="100px" viewBox="0 0 98.455 100" enable-background="new 0 0 98.455 100" xml:space="preserve">
				<path d="M98.451,100h-8.956V84.869H9.042V100H0V42.959c0-2.464,1.945-4.469,4.418-4.469v-0.003c2.469,0,4.624,2.008,4.624,4.473
				  v31.079h80.454V52.016c0-2.466,2.012-4.471,4.482-4.471c2.472,0,4.474,2.005,4.474,4.471V100z"/>
				<path d="M21.157,48.058c3.801,0,6.879,3.075,6.879,6.875c0,3.802-3.078,6.881-6.879,6.881c-3.806,0-6.891-3.079-6.891-6.881
				  C14.267,51.133,17.351,48.058,21.157,48.058"/>
				<path d="M28.035,67.215c0,1.869-1.519,3.391-3.391,3.391h-9.778c-1.873,0-3.388-1.521-3.388-3.391c0-1.865,1.515-3.38,3.388-3.38
				  h9.778C26.516,63.835,28.035,65.35,28.035,67.215"/>
				<path d="M80.712,50.732c3.024,0,5.466,2.367,5.493,5.374l0.012,14.503H31.01V50.736L80.712,50.732z"/>
				<path d="M47.998,47.585V16.19c0-3.378-2.748-6.124-6.12-6.124c-3.359,0-6.092,2.73-6.092,6.088c0,0.569-0.462,1.035-1.031,1.035
				  c-0.57,0-1.031-0.466-1.031-1.035c0-0.751-0.609-1.356-1.36-1.356c-0.749,0-1.354,0.605-1.354,1.356
				  c0,2.071,1.679,3.748,3.745,3.748c2.069,0,3.747-1.677,3.747-3.748c0-1.859,1.513-3.37,3.376-3.37c1.872,0,3.4,1.525,3.4,3.406
				  v31.395H47.998z"/>
				<path d="M36.595,38.065h3.454c0,0,0.681-2.945,0.681-7.641s-0.681-7.639-0.681-7.639h-8.83c0,0-0.791,2.378-0.791,7.639
				  c0,5.262,0.791,7.641,0.791,7.641h3.515c0,0.007-0.007,0.016-0.007,0.027c0.003,0.058,0.109,5.727-3.604,9.493h2.446
				  C36.653,43.463,36.598,38.457,36.595,38.065"/>
				<path d="M61.107,35.588h37.348V0H61.107V35.588z M64.3,8.085c0-2.625,2.12-4.749,4.758-4.749h21.47c2.629,0,4.756,2.124,4.756,4.749
				  v12.906H92.4l-1.784-4.853c-0.107-0.294-0.396-0.495-0.713-0.491c-0.314,0-0.595,0.204-0.702,0.5c0,0-0.506,1.43-0.999,2.837
				  c-0.76-3.174-2.358-9.875-2.358-9.875c-0.083-0.354-0.412-0.598-0.776-0.574c-0.369,0.017-0.663,0.302-0.705,0.663
				  c0,0-1.225,10.918-1.578,14.042c-0.639-0.958-1.274-1.918-1.274-1.918c-0.14-0.206-0.373-0.331-0.628-0.331h-2.899
				  c-0.296-0.814-1.778-4.853-1.778-4.853c-0.113-0.294-0.396-0.495-0.715-0.491c-0.318,0-0.599,0.204-0.7,0.5
				  c0,0-0.508,1.43-1.007,2.837c-0.758-3.17-2.357-9.875-2.357-9.875c-0.084-0.354-0.411-0.598-0.775-0.574
				  c-0.365,0.017-0.659,0.302-0.705,0.663c0,0-1.222,10.918-1.578,14.042c-0.635-0.958-1.274-1.918-1.274-1.918
				  c-0.137-0.206-0.373-0.331-0.624-0.331H64.3V8.085z M90.527,32.622h-21.47c-2.638,0-4.758-2.131-4.758-4.759v-5.369h1.762
				  c0.371,0.552,2.196,3.299,2.196,3.299c0.175,0.264,0.497,0.387,0.804,0.314c0.307-0.074,0.537-0.333,0.572-0.647
				  c0,0,0.809-7.205,1.33-11.814c0.868,3.66,1.948,8.167,1.948,8.167c0.077,0.326,0.356,0.562,0.69,0.577
				  c0.337,0.02,0.64-0.186,0.748-0.5c0,0,0.613-1.736,1.158-3.271c0.578,1.572,1.249,3.383,1.249,3.383
				  c0.102,0.295,0.386,0.492,0.7,0.492h3.021c0.369,0.552,2.196,3.299,2.196,3.299c0.176,0.264,0.493,0.387,0.8,0.314
				  c0.309-0.074,0.541-0.333,0.572-0.647c0,0,0.812-7.205,1.334-11.817c0.871,3.664,1.948,8.17,1.948,8.17
				  c0.078,0.326,0.356,0.562,0.689,0.577c0.338,0.02,0.641-0.186,0.749-0.5c0,0,0.617-1.736,1.158-3.271
				  c0.575,1.572,1.243,3.383,1.243,3.383c0.107,0.295,0.388,0.492,0.702,0.492h3.411v5.369C95.283,30.491,93.156,32.622,90.527,32.622"
				  />
				</svg>')
			this.$thing2.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Layer_1" x="0px" y="0px" width="56.626px" height="100px" viewBox="0 0 56.626 100" enable-background="new 0 0 56.626 100" xml:space="preserve">
				<path d="M26.341,71.348c0.319,0.186,0.737,0.073,0.923-0.249l1.023-1.776c0.188-0.319,0.075-0.737-0.246-0.923L5.874,55.598  c-0.321-0.183-0.735-0.07-0.919,0.249l-1.027,1.776c-0.184,0.319-0.074,0.733,0.248,0.919L26.341,71.348z"/>
				<path d="M6.661,72.513c0.321,0.187,0.735,0.073,0.919-0.246l3.45-5.974l-6.055-3.496l-3.447,5.974  c-0.186,0.32-0.074,0.738,0.246,0.92L6.661,72.513z"/>
				<path d="M13.001,76.174l4.888,2.822c0.319,0.186,0.733,0.073,0.919-0.246l3.449-5.971l-6.053-3.5l-3.452,5.979  C12.571,75.573,12.679,75.987,13.001,76.174z"/>
				<path d="M52.575,90.716h-6.314c6.383-6.097,10.365-14.687,10.365-24.213c0-8.908-3.481-17-9.154-22.998  c-0.707,3.266-2.996,5.942-6.023,7.188c3.669,4.241,5.894,9.766,5.894,15.81c0,13.37-10.841,24.213-24.21,24.213H4.047  C1.824,90.716,0,92.537,0,94.763V100h56.626v-5.237C56.626,92.537,54.803,90.716,52.575,90.716z"/>
				<circle cx="37.631" cy="41.381" r="7.291"/>
				<path d="M25.102,63.077l7.501-12.986c-3.007-1.743-5.037-4.989-5.037-8.71c0-5.55,4.516-10.067,10.066-10.067  c1.832,0,3.547,0.498,5.028,1.358l5.835-10.107c0.278-0.482,0.334-1.035,0.199-1.536c-0.132-0.5-0.456-0.951-0.938-1.229  l-1.149-0.665L52.876,8.28l0.487,0.284c0.372,0.216,0.852,0.086,1.067-0.284l1.185-2.052c0.212-0.369,0.087-0.848-0.284-1.063  l-8.747-5.061c-0.371-0.215-0.852-0.085-1.065,0.287l-1.185,2.051c-0.215,0.37-0.085,0.849,0.284,1.064l0.487,0.283l-6.271,10.86  l-1.015-0.586c-0.48-0.277-1.034-0.333-1.534-0.197c-0.5,0.134-0.951,0.457-1.23,0.939L11.664,55.32L25.102,63.077z"/>
				</svg>')
			this.$thing3.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Calque_1" x="0px" y="0px" width="100px" height="49.4481236203px" viewBox="0 0 453.756 224.188" enable-background="new 0 0 453.756 224.188" xml:space="preserve">
				<path d="M428.26,180.379l25.496-75.182H350.362c-2.143,0-6.061,2.795-11.781,8.385c-5.722,5.617-9.613,8.386-11.729,8.386h-39.002  c-2.534,0-6.087,1.959-10.736,5.878c-4.676,3.944-7.993,5.852-9.979,5.852h-21.917V62.173l-18.521,71.525h-22.037v-17.875h-24.667  v-75h-32.279V0h-17.75v40.822h-22.304v38.333h-51v54.542H0v43.442c0,4.911,4.963,11.99,14.929,47.048h430.259l-12.121-35.894  L428.26,180.379z"/>
				</svg>')
			this.$thing4.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Layer_1" x="0px" y="0px" width="100px" height="100px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve">
				<g>
					<path d="M29.1,27.091c4.081,1.252,8.389-1.04,9.643-5.12c1.219-4.067-1.061-8.36-5.141-9.604   c-4.053-1.257-8.365,1.023-9.617,5.104C22.741,21.55,25.045,25.845,29.1,27.091z"/>
					<path d="M66.584,72.236l-1.375-10.702c-0.277-1.353-1.122-2.549-2.379-3.261l-8.16-2.449l13.507-8.184l16.513,7.313   c0.105,0.049,0.204,0.097,0.3,0.146c2.498,0.868,5.237-0.433,6.107-2.933c0.82-2.355-0.29-4.9-2.499-5.939l-18.816-8.384   c-0.094-0.025-0.154-0.074-0.253-0.098c-1.352-0.47-2.786-0.302-3.933,0.327l-12.433,7.591l-2.919-18.03l17.85-10.44   c0.846-0.47,1.509-1.231,1.786-2.196c0.57-1.954-0.54-4.008-2.498-4.599c-1.036-0.3-2.124-0.134-2.992,0.412l-25.44,14.941   c-0.894,0.47-1.667,1.135-2.33,1.905l-10.73,14.4l-14.771-1.763c-0.941,0.325-1.75,1.038-2.171,2.003   c-0.822,1.882,0.048,4.056,1.906,4.853c0.784,0.362,1.629,0.41,2.415,0.194l15.037,1.701c0.545-0.217,1.037-0.544,1.436-0.989   l6.106-7.667l2.919,16.548c0.543,2.332,2.102,4.382,4.309,5.492l13.108,3.91l0.696,5.436c-2.246-0.062-4.54-0.095-6.876-0.095   c-26.405,0-47.81,4.044-47.81,9.036c0,4.99,21.404,9.036,47.81,9.036c26.401,0,47.804-4.046,47.804-9.036   C97.807,76.824,84.812,73.511,66.584,72.236z"/>
				</g>
				</svg>')
			this.$thing5.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Layer_1" x="0px" y="0px" width="98.202px" height="100px" viewBox="0 0 98.202 100" enable-background="new 0 0 98.202 100" xml:space="preserve">
				<g>
					<path d="M16.374,74.926L4.256,86.292C0.432,89.88-1.098,94.463,0.84,96.529c1.936,2.065,6.607,0.832,10.432-2.757l8.112-7.609   L16.374,74.926z"/>
				</g>
				<circle cx="53.349" cy="91.323" r="8.677"/>
				<path d="M68.872,90.472L45.687,42.681c1.017-0.936,1.658-2.275,1.658-3.766c0-2.833-2.296-5.128-5.128-5.128h-5.915L23.579,21.064  c-1.304-2.309-4.215-3.919-7.604-3.919c-4.605,0-8.338,2.969-8.338,6.63v33.771h5.924l7.488,27.942l0.042-0.012l2.654,9.904  c0.733,2.736,3.549,4.358,6.292,3.623c2.741-0.734,4.369-3.546,3.636-6.283l-2.654-9.904l-6.771-25.271h0.066V36.394l7.648,7.648  h10.255c0.054,0,0.106-0.006,0.16-0.008l23.285,47.997l0,0l1.558,3.211l27.409-13.299l-1.558-3.21L68.872,90.472z"/>
				<polygon points="83.018,80.718 72.919,59.901 71.09,60.789 67.723,53.849 56.286,59.397 69.752,87.154 "/>
				<polygon points="74.23,59.264 84.33,80.081 98.202,73.352 84.736,45.595 73.3,51.144 76.665,58.083 "/>
				<path d="M37.216,5.521h-7.553C28.506,2.304,25.438,0,21.823,0c-4.605,0-8.338,3.732-8.338,8.337c0,4.605,3.733,8.338,8.338,8.338  c3.622,0,6.696-2.313,7.846-5.541C34.052,10.358,37.216,8.138,37.216,5.521z"/>
				</svg>')
			this.$thing6.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Layer_1" x="0px" y="0px" width="100px" height="100px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve">
				<path d="M16.806,78.248h65.855c3.33,0,6.043-2.713,6.043-6.043V28.943c0-3.333-2.713-6.046-6.043-6.046H61.743v-3.399  c0-3.33-2.717-6.042-6.05-6.042H43.77c-3.333,0-6.043,2.713-6.043,6.042v3.399H16.806c-3.333,0-6.043,2.713-6.043,6.046v43.262  C10.763,75.535,13.472,78.248,16.806,78.248z M43.219,19.498c0-0.301,0.247-0.547,0.551-0.547h11.923  c0.305,0,0.551,0.247,0.551,0.547v3.399H43.219V19.498z M16.254,28.943c0-0.304,0.247-0.551,0.551-0.551h20.921h5.492h13.025h5.499  h20.918c0.301,0,0.548,0.247,0.548,0.551v43.262c0,0.309-0.247,0.555-0.548,0.555H16.806c-0.305,0-0.551-0.246-0.551-0.555V28.943z"/>
				<path d="M58.557,49.16l-6.077,6.073V39.279c0-1.519-1.229-2.748-2.748-2.748c-1.518,0-2.748,1.229-2.748,2.748v15.954L40.91,49.16  c-0.539-0.54-1.241-0.806-1.946-0.806c-0.702,0-1.407,0.266-1.942,0.806c-1.071,1.071-1.071,2.81,0,3.885l10.767,10.767  c0.035,0.031,0.069,0.062,0.104,0.093c0.031,0.023,0.062,0.054,0.092,0.085c0.031,0.023,0.062,0.046,0.092,0.069  c0.039,0.031,0.081,0.062,0.124,0.093c0.023,0.015,0.05,0.022,0.073,0.038c0.054,0.039,0.104,0.069,0.158,0.101  c0.02,0.008,0.039,0.015,0.054,0.022c0.062,0.031,0.127,0.062,0.193,0.093c0.011,0,0.027,0.008,0.038,0.016  c0.07,0.03,0.139,0.054,0.212,0.077c0.015,0,0.031,0,0.042,0.008c0.073,0.022,0.143,0.038,0.22,0.054  c0.027,0.008,0.054,0.008,0.081,0.016c0.062,0.008,0.124,0.015,0.185,0.03c0.088,0,0.181,0.008,0.273,0.008l0,0  c0.008,0,0.016,0,0.02,0c0.084,0,0.169-0.008,0.254-0.008c0.073-0.016,0.146-0.022,0.219-0.038c0.016,0,0.031-0.008,0.046-0.008  c0.089-0.016,0.173-0.039,0.254-0.062c0.004,0,0.004,0,0.004,0c0.169-0.054,0.335-0.123,0.489-0.2c0.004,0,0.004,0,0.008-0.008  c0.073-0.039,0.143-0.085,0.212-0.131c0.004,0,0.012,0,0.02-0.008c0.069-0.047,0.139-0.101,0.204-0.146  c0.004-0.008,0.008-0.008,0.012-0.016c0.073-0.054,0.139-0.123,0.204-0.186l10.76-10.759c1.079-1.075,1.079-2.813,0-3.885  C61.366,48.085,59.632,48.085,58.557,49.16z"/>
				<path d="M97.013,81.901H2.504c-1.519,0-2.748,1.233-2.748,2.744c0,1.525,1.229,2.751,2.748,2.751h94.508  c1.511,0,2.744-1.226,2.744-2.751C99.757,83.135,98.523,81.901,97.013,81.901z"/>
				</svg>')
			this.$thing7.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Layer_1" x="0px" y="0px" width="100px" height="100px" viewBox="-346 256 100 100" enable-background="new -346 256 100 100" xml:space="preserve">
				<path d="M-246.029,288.423h-9.613l-2.025-15.36c0,0-1.025-8.746-2.062-9.846c-1.296-1.374-2.904-1.514-2.904-1.514  c-0.001,0-66.627,0-66.627,0c0,0-1.607,0.14-2.904,1.514c-1.036,1.1-2.063,9.846-2.063,9.846l-2.026,15.36h-9.519v14.902  l7.396,1.186l-0.967,7.331v40.581c0,1.905,1.545,3.454,3.453,3.454h6.285c1.91,0,3.456-1.549,3.456-3.454v-9.602h60.408v9.602  c0,1.905,1.545,3.454,3.453,3.454h6.286c1.908,0,3.453-1.549,3.453-3.454v-40.581l-0.965-7.315l7.487-1.201V288.423z   M-326.204,325.969c-3.351,0-6.066-2.714-6.066-6.065c0-3.35,2.716-6.065,6.066-6.065c3.349,0,6.065,2.716,6.065,6.065  C-320.139,323.255-322.854,325.969-326.204,325.969z M-277.599,325.231h-36.993v-3.983h37.013L-277.599,325.231z M-277.568,318.798  h-37.023v-3.983h37.042L-277.568,318.798z M-265.74,325.969c-3.35,0-6.065-2.714-6.065-6.065c0-3.35,2.716-6.065,6.065-6.065  s6.066,2.716,6.066,6.065C-259.674,323.255-262.391,325.969-265.74,325.969z M-332.823,299.324l2.786-24.683h67.86l3.101,24.683  H-332.823z"/>
				</svg>')
			this.$thing8.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Layer_1" x="0px" y="0px" width="100px" height="100px" viewBox="-346 256 100 100" enable-background="new -346 256 100 100" xml:space="preserve">
				<path d="M-295.28,256.292c-21.429,0-38.795,17.37-38.795,38.79V356h77.586v-60.918C-256.489,273.662-273.854,256.292-295.28,256.292  z M-295.28,324.658c-16.071,0-29.096-13.024-29.096-29.091s13.025-29.093,29.096-29.093c16.069,0,29.093,13.026,29.093,29.093  S-279.211,324.658-295.28,324.658z"/>
				<path d="M-295.28,298.335c-0.451,0-0.902-0.108-1.315-0.33c-0.904-0.479-1.467-1.423-1.467-2.452v-20.408  c0-1.538,1.245-2.785,2.782-2.785c1.536,0,2.78,1.248,2.78,2.785v15.219l8.691-5.785c1.282-0.852,3.006-0.505,3.855,0.772  c0.853,1.275,0.506,3.007-0.773,3.854l-13.013,8.667C-294.205,298.181-294.743,298.335-295.28,298.335L-295.28,298.335z"/>
				</svg>')
			this.$thing9.html('<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="stroke: ' + tempy + '; fill: ' + tempy + ';" version="1.1" id="Layer_1" x="0px" y="0px" width="100px" height="100px" viewBox="0 0 100 100" enable-background="new 0 0 100 100" xml:space="preserve">
				<polygon points="45.211,69.244 44.187,72.105 36.623,99.198 35.605,98.914 43.163,71.857 37.784,53.398 38.576,53.092 "/>
				<polygon points="55.052,69.244 56.076,72.105 63.64,99.198 64.659,98.914 57.1,71.857 62.479,53.398 61.688,53.092 "/>
				<polygon points="35.605,64.045 18.054,83.617 17.272,82.915 34.084,64.161 33.435,55.409 34.586,55.246 "/>
				<g>
					<polygon points="45.903,32.349 45.903,35.88 35.61,30.501 40.756,20.541 30.574,2.146 31.498,1.633 42.24,21 38.149,29.614  "/>
				</g>
				<path d="M45.903,44.514l-1.056-5.015c0,0-15.923,4.531-26.348,8.49c-12.668,8.094,5.873,10.374,12.448,7.698  C37.325,53.091,45.903,44.514,45.903,44.514z"/>
				<polygon points="64.659,64.063 82.209,83.636 82.99,82.934 66.179,64.18 66.828,55.428 65.678,55.265 "/>
				<g>
					<polygon points="54.679,32.35 54.679,35.881 64.972,30.502 59.825,20.542 70.008,2.147 69.084,1.635 58.343,21.001 62.434,29.616     "/>
				</g>
				<path d="M54.36,44.532l1.056-5.015c0,0,15.924,4.531,26.349,8.49c12.669,8.094-5.873,10.374-12.448,7.698  C62.938,53.109,54.36,44.532,54.36,44.532z"/>
				<g>
					<path d="M52.3,44.921c0.555,2.56,0.333,5.336,0.333,9.469c0,7.723-1.209,13.988-2.708,13.988c-1.494,0-2.703-6.266-2.703-13.988   c0-4.317,0-7.067,0.591-9.638c-1.167-1.356-1.583-5.036-1.583-7.981c0-3.003,0.824-5.622,2.037-6.962v-0.005   c-0.717-0.718-1.177-1.853-1.177-3.125c0-1.884,1.008-3.462,2.359-3.858l0.412-21.188h0.528l0.448,21.204   c1.336,0.412,2.323,1.974,2.323,3.842c0,1.272-0.459,2.407-1.177,3.125v0.005c1.215,1.34,2.037,3.958,2.037,6.962   C54.021,39.976,53.646,43.676,52.3,44.921z"/>
				</g>
				</svg>')
			# $css.html($css.html() + "\n.rand" + i + " svg {stroke: " + tempy + "; fill: " + tempy + ";}")
			$("div").remove()
			a = Math.floor(Math.random() * 30) + 1
			for yo in [0...a]
				r = Math.floor(Math.random() * 9) + 1
				tempp = this["$thing" + r].clone()
				trans = Math.random()
				tempp.css({
					position: "absolute"
					left: (Math.floor(Math.random() * 1150))
					top: (Math.floor(Math.random() * 575))
					opacity: trans
				})
				tmp2 = tempp.children("svg")
				tempy = "#" + getColor() + getColor() + getColor()
				tmp2.css("stroke", tempy).css("fill", tempy)
				$(document.body).append(tempp)
		makeCrazy()
		window.setInterval(makeCrazy, 700)
)