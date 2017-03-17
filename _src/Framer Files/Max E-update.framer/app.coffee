


# Material Design Animation Curves
mdCurve = "cubic-bezier(0.4, 0.0, 0.2, 1)"
mdCurveIn = "cubic-bezier(0.0, 0.0, 0.2, 1)"
mdCurveOut = "cubic-bezier(0.4, 0.0, 1, 1)"
ortCurve = "cubic-bezier(0.26, 0.86, 0.44, 0.985)"
koenSpring = "spring(200, 20, 0)"
BoerSpring = "spring(400, 30, 0)"
KrennSpring = "spring(300,25,0)"
# Use the third value to continue a motion. Ex: take a draggable you can take the current velocity and use it as the initial velocity for a spring



############################################################
# CONTENT & VARIABLES
############################################################
mainContent = [
	{ img: "01", name: "Shintaro Nagamine", celeb: "Jimi Hendrix" }
	{ img: "02", name: "Amber Mitchell", celeb: "Twiggy" }
	{ img: "03", name: "Kayhan Golkar", celeb: "Bill Murray" }
	{ img: "04", name: "Advertisement", celeb: "Levi's" }
	{ img: "05", name: "Daniel Norman", celeb: "Jean Michel Basquiat" }
	{ img: "06", name: "Paige Russell", celeb: "Feist" }
	{ img: "07", name: "Loli at Wilhelmina", celeb: "Boy George" }
	{ img: "08", name: "Shotaro Kobayashi", celeb: "David Lynch" }
	{ img: "09", name: "Advertisement" , celeb: "Apple" }
	{ img: "10", name: "Valentina Oleinkova", celeb: "David Bowie" }
	{ img: "11", name: "Yurie Ishitsuka", celeb: "Madonna" }
	]

profileContent = [
	{ img: "01", name: "You", celeb: "Jimi Hendrix" } ]
# 	{ img: "02", name: "You", celeb: "Jimi Hendrix" } ]
	
jrdSpring = "spring(500, 50, 20)"
gutter = 8
btmBarHeight = 96 * 2

miniScrolls = []
fullScrolls = []


# Make each layer draggable function
makeDraggable = (layer) ->
	layer.draggable.enabled = true
	layer.draggable.horizontal = false
	layer.draggable.directionLock = true
# 	layer.draggable.speedY = .5
	layer.draggable.constraints = { y: 0 } 
# Makes the layer draggable vertically

# Helper function to toggle likes
toggleLike = (layer) ->
	pinkLayer = layer.children[0]
	if pinkLayer.states.current is "default"
		pinkLayer.states.switch("liked",curve: "spring(500,30,30)")
	else
		pinkLayer.states.switch("default", curve: "ease", time: .1)

# Hide and show bottom bars helper function
toggleAllBottomBars = (scroller, stateName) ->
	for item in scroller.content.children
		item.subLayersByName("btmBar")[0].states.switch stateName, curve: ortCurve, time: .15

# Toggle opacity hack helper
toggleItemOpacity = (scroller, opacity) ->
	for item in scroller.content.children
		if item.draggable.isDragging is false
			item.opacity = opacity

################################################## 
# The biggie.

# Build views for scrolling (used for profile and the main view)
createScrollView = (view, content) ->

	# Small scroller for the "zoomed out" view
	miniScroll = new ScrollComponent
		width: view.width 
		height: view.height / 2
		x: Align.center
		midY: view.midY
		parent: view
# 		originX: .5
# 		originY: .5
		scrollVertical: false
		name: "mini" # Used to reference it later.
		clip: false
		originX: 0
		directionLock: true
		contentInset: left: view.width / 4, right: view.width / 4
		backgroundColor: "rgba(0,0,0,.3)"
	miniScroll.velocityThreshold = .0001
	miniScroll.content.clip = false
	miniScroll.content.draggable.directionLockThreshold = x: 0, y: 20
	miniScrolls.push(miniScroll)
# 	miniScroll.on Events.Click, (event) ->
# 		event.stopPropagation()
	
	# Fullscreen scrolling layer
	fullScroll = new PageComponent
		width: view.width 
		height: view.height
		x: Align.center
		midY: view.midY
		parent: view
		scrollVertical: false
		speedY: 0
		name: "full"
		directionLock: true
		backgroundColor: "rgba(0,0,0,.3)"
		opacity: 0
	fullScroll.content.draggable.directionLockThreshold = x: 20, y: 0
	fullScrolls.push(fullScroll)

	# For the content...
	for i in [0...content.length]
		# Create a little layer in the mini view
		miniLayer = new Layer
			parent: miniScroll.content
			width: miniScroll.width / 2
			height: miniScroll.height
			custom: i
			image: "images/#{content[i].img}.png"
			x: gutter + ((view.width / 2 ) + gutter) * i
		# Make it draggable
		makeDraggable(miniLayer)
		
		# Create the fullscreen version
		fullLayer = new Layer
			parent: fullScroll.content
			width: fullScroll.width
			custom: i
			height: fullScroll.height
			image: "images/#{content[i].img}.png"
			x: gutter + ((view.width ) + gutter) * i
		makeDraggable(fullLayer)
		
		# Chrome for the fullscreen versions
		bottomBar = new Layer
			width: fullLayer.width
			parent: fullLayer
			height: 72 * 2
			y: Align.bottom
			opacity: 0
			name: "btmBar"
			style: "background" : "-webkit-linear-gradient(top, rgba(0,0,0,0) 0%,rgba(0,0,0,1) 100%)"
# 			backgroundColor: "rgba(0,0,0,.3)"
		bottomBar.states.add
			shown: opacity: 1
		
		
		
		ic_heart = new Layer
			size: 96
			image: "images/ic_heart_white.png"
			parent: bottomBar
			x: Align.right -36
			y: Align.center
		ic_heart_pink = new Layer
			size: 96
			image: "images/ic_heart_pink.png"
			parent: ic_heart
			scale: 0
		ic_heart_pink.states.add
			liked: scale: 1
		personText = new Layer
			parent: bottomBar
			x: 32
			y: 32
			width: bottomBar.width - 32 - ic_heart.width - 32
			height: 28
			backgroundColor: ""
			style: "font" : "600 28px/28px Roboto"
			html : content[i].name + ' <span style="font-weight: normal; opacity: .5">as</span>'
		if content[i].name is "Advertisement"
			personText.html = content[i].name
			ic_heart.opacity = 0
		celebText = new Layer
			parent: bottomBar
			x: 32
			width: personText.width
			backgroundColor: ""
			y: personText.maxY + 16
			height: 28
			style: "font" : "400 28px/28px Roboto"
			html : content[i].celeb
		ic_heart.on Events.Click, (event, layer) ->
			toggleLike(layer)
			
	##################################################
	# Interactions...
	##################################################
	
	# Go through all mini items...
	for item in miniScroll.content.children 
		item.on Events.Click, (event, layer) =>
			mainNav.states.switch "hidden"
			# Transition to the other scroll
# 				toggleItemOpacity(fullScroll, 1)
			transitionToOtherScroll(view, layer, "full")
			fullScroll.content.backgroundColor = "rgba(0,0,0,1)"
			# Put the original layer back to og spot.
			layer.scale = 1
			# But hide it...
			layer.opacity = 0

		# When you start swiping...
		item.on Events.DragMove, (event, layer) => 
			layer.bringToFront()
			# Change scale based on y value
			layer.scale = Utils.modulate(layer.y, [0, -miniScroll.y], [1,1.5], true)
			
		# When you're done swiping...
		item.on Events.DragEnd, (event, layer) =>
			# If it's over a certain amount scaled...
			if layer.scale >= 1.2
				mainNav.states.switch "hidden"
				# Transition to the other scroll
# 				toggleItemOpacity(fullScroll, 1)
				transitionToOtherScroll(view, layer, "full")
				fullScroll.content.backgroundColor = "rgba(0,0,0,1)"
				# Put the original layer back to og spot.
				layer.scale = 1
				# But hide it...
				layer.opacity = 0
			
			# Otherwise,just animate the scale back.
			else layer.animate properties: scale: 1
			
			# Snap to that current page regardless
			miniScroll.scrollToLayer(layer)
	
	# Now do something mostly the same to the fullscreen ones...
	for item in fullScroll.content.children
		item.on Events.DragStart, (event, layer) ->
			miniScroll.scrollToLayer(miniScroll.content.children[@.custom],0,0,false)
			mini.opacity = 1 for mini in miniScroll.content.children
			miniScroll.content.children[@.custom].opacity = 0
			
			toggleAllBottomBars(fullScroll, "default")
			toggleItemOpacity(fullScroll, 0)
# 			for mini, i in miniScroll
# 				if mini is miniScroll.content.children[layer.custom]
# 					mini.opacity = 0
# 				else
# 					mini.opacity = 1
		item.on Events.DragMove, (event) -> 
# 			miniScroll.content.x = startX		
# 			print @.y
			opacityLevel = Utils.modulate(@.y, [0, view.height / 2], [.8,.3], true)
			@.bringToFront()
			@.scale = Utils.modulate(@.y, [0, view.height / 2], [1,.5], true)
			@.parent.backgroundColor = "rgba(0,0,0,#{opacityLevel})"
# 			print @.parent.backgroundColor
		item.on Events.DragEnd, (event) ->
			if @.y >= 100
				mainNav.states.switch "default"
# 				miniScroll.content.children[@.custom].opacity = 1
				@.parent.animate properties: backgroundColor: "rgba(0,0,0,0)"
				transitionToOtherScroll(view, @, "mini")
				@.scale = 1
				@.opacity = 0
			else
				@.animate properties:
					scale: 1
				toggleAllBottomBars(fullScroll, "shown")
				for item in view.subLayersByName("full")[0].content.children
					item.opacity = 1

	fullScroll.sendToBack()
	miniScroll.updateContent()
	fullScroll.updateContent()
	
	if view is mainView
		fullScroll.opacity = 1
		fullScroll.bringToFront()
		toggleAllBottomBars(fullScroll, "shown")
		


# Make a fake layer
# createRingerLayer = (parentView) ->
# 	ringer = touchedLayer.copy()
# 	touchedLayer.opacity = 0
# 	ringer.custom = touchedLayer.custom
# 	ringer.x = touchedLayer.screenFrame.x
# 	ringer.y = touchedLayer.screenFrame.y
# 	ringer.originX = 0
# 	ringer.originY = 0
# 	ringer.parent = parentView
# 	ringer.bringToFront()
	
# Align the corresponding scroller
alignSisterLayer = (index, toScroll) ->
	sisterLayer = toScroll.content.children[index]
	toScroll.scrollToLayer(sisterLayer,0, 0, false)

# Transition from one scroll to the next.
transitionToOtherScroll = (view, layer, scrollView) ->
	
	toScrollView = view.subLayersByName(scrollView)[0]
	
	# Create a fake layer to transition.
	ringer = layer.copy()
	ringer.x = layer.screenFrame.x
	ringer.y = layer.screenFrame.y
	ringer.name = "ringer"
	ringer.originX = 0
	ringer.originY = 0
	
	if scrollView is "full"
		ringer.animate 
			properties:
				scale: 2
				x: 0
				y: 0
			curve: KrennSpring
		
	else if scrollView is "mini"
# 		print toScrollView.content.children[layer.custom].screenFrame.x
		ringer.animate 
			properties:
				scale: .5
				x: toScrollView.content.children[layer.custom].screenFrame.x
				y: toScrollView.content.children[layer.custom].screenFrame.y
			curve: KrennSpring
		view.subLayersByName("full")[0].animate properties:
			backgroundColor: "rgba(0,0,0,0)"
	
	# After it's in place, do this....
	ringer.on Events.AnimationEnd, =>
		if scrollView is "mini"
			layer.parent.parent.opacity = 0
			toScrollView.content.children[layer.custom].opacity = 1
			layer.opacity = 1
		layer.y = 0
		layer.scale = 1
# 		toScrollView = view.subLayersByName(scrollView)[0]
		if scrollView is "full"
			alignSisterLayer(layer.custom, toScrollView)
			toggleAllBottomBars(toScrollView, "shown")
			
		toScrollView.bringToFront()
		toScrollView.opacity = 1
		toggleItemOpacity(toScrollView, 1)
# 		ringer.animate properties: opacity: 0
		ringer.destroy()
# 	ringer.on "change:opacity", ->
# 		if @.opacity = 0 then @.destroy()
		

################################################## 
# Views

loadingScreen = new Layer 
	backgroundColor: "white"
	size: Screen.size
logo = new Layer
	width: 364
	height: 116
	image: "images/logo.png"
	parent:loadingScreen
	ignoreEvents: false
logo.center()

mainView = new BackgroundLayer backgroundColor: "black", clip: true
createScrollView(mainView, mainContent)
mainView.states.add
	profile: x: -Screen.width, y: 0
watermark = new Layer
	width: 150
	height: 46
	image: "images/watermark.png"
	parent: mainView
	x: Align.center
	y: 36
watermark.sendToBack()


profileView = new BackgroundLayer backgroundColor: "black", clip: true
profileView.x = Screen.width
createScrollView(profileView, profileContent)
profileView.states.add
	profile: x: 0
ic_settings = new Layer
	size: 96
	image: "images/ic_settings.png"
	parent: profileView
	x: Align.right -36
	y: 36


profileInfo = new Layer
	width: 370
	height: 84
	image: "images/profileInfo.png"
	parent: profileView
	x: 36
	y: 36

cameraView = new BackgroundLayer backgroundColor: "black"
# stefania = new VideoLayer
# 	width: cameraView.width
# 	height: cameraView.height
# 	parent: cameraView
# 	video: "images/stefanie_mute.mov"
# stefania.player.loop = true
# stefania.player.muted = true
# stefania.player.volume = 0
# stefania.player.audioTracks = {}
# stefania.player.play()
# stefania.player.pause()
# print stefania.player.audioTracks
ic_cameraRoll = new Layer
	size: 96
	image: "images/ic_cameraRoll.png"
	parent: cameraView
	y: Align.bottom -24
	x: 36
ic_takePhoto = new Layer
	width: 144
	height: 144
	image: "images/ic_takePhoto.png"
	parent: cameraView
	y: Align.bottom -12
	x: Align.center
ic_cameraSwap = new Layer
	size: 96
	y: Align.bottom -24
	image: "images/ic_cameraSwap.png"
	parent: cameraView
	x: Align.right -36
cameraView.on Events.Click, ->
	mainView.x = 0
	profileView.x = Screen.height
	ic_feed.states.switchInstant "active"
	ic_camera.states.switchInstant "default"
	mainView.states.switch "default"
	profileView.states.switch "default"
	mainNav.states.switch "default"
# 	Utils.delay .4, => stefania.player.pause()



mainNav = new Layer
	width: mainView.width
	height: 96 + 36
	backgroundColor: ""
	y: Align.bottom
	z: 1
mainNav.bringToFront()
ic_feed = new Layer
	size: 96
	image: "images/ic_feed.png"
ic_camera = new Layer
	size: 96
	image: "images/ic_camera.png"
ic_profile = new Layer
	size: 96
	image: "images/ic_profile.png"

mainNavIcons = [ic_feed, ic_camera, ic_profile]
for icon, i in mainNavIcons
	icon.parent = mainNav
	icon.y = Align.center
	icon.opacity = .5
	if i is 0 then icon.x = 36
	else if i is 1 then icon.x = Align.center
	else if  i is 2 then icon.x = Align.right -36
	icon.states.add
		active: opacity: 1
	if i is 0 then icon.states.switchInstant "active"
	icon.on Events.Click, ->
		if @.states.current != "active"
			@.states.switchInstant "active"
			for item in mainNavIcons
				if item != @ then item.states.switchInstant "default"
			if @ == ic_feed
				mainView.states.switch "default"
				profileView.states.switch "default"
			else if @ == ic_camera
				mainView.animate properties: y: -Screen.height
				profileView.animate properties: y: -Screen.height
				mainNav.states.switch "camera"
# 				stefania.player.play()
# 				stefania.player.muted = true
			else if @ == ic_profile
				mainView.states.switch "profile"
				profileView.states.switch "profile"
mainNav.states.add
	hidden: y: Screen.height, opacity: 0
	camera: y: 0 - 96 - 36

# Views



############################################################
# Start it up
############################################################
Framer.Defaults.Animation =  curve: jrdSpring
# loadingScreen.sendToBack()
mainView.bringToFront()
mainNav.bringToFront()
mainNav.states.switchInstant "hidden"
loadingScreen.bringToFront()
if Utils.isFramerStudio()
	loadingScreen.sendToBack()
	loadingScreen.destroy()
else
	Utils.domComplete -> 
		Utils.delay 1.8, ->
			loadingScreen.animate
				properties: opacity: 0
				time: .35
				curve: "linear"
			loadingScreen.on Events.AnimationEnd, -> 
				loadingScreen.sendToBack()
				loadingScreen.destroy()

# Use Roboto
Utils.insertCSS("@import url('//fonts.googleapis.com/css?family=Roboto:200,400,500,700,300,100');")



