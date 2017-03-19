Framer.Device.customize
  deviceType: Framer.Device.Type.Phone
  screenWidth: 750
  screenHeight: 1334
  deviceImage: "http://www.blainebillingsley.com/resources/iphone-white.png"
  deviceImageWidth: 990
  deviceImageHeight: 1982

################################################################################
# Setup and variables
################################################################################

# Use Roboto
Utils.insertCSS("@import url('//fonts.googleapis.com/css?family=Roboto:200,400,500,700,300,100');")

# Helper function to style text. Ex: styleText(textButton, 32, blue, true)
styleText = (layer, textSize, textColor, textLH) ->
	layer.style = {
		"font-family" : "Roboto",
		fontSize : textSize + "px",
		color : textColor
		lineHeight : textLH + "px" }

# Material Design Animation Curves
mdCurve = "cubic-bezier(0.4, 0.0, 0.2, 1)"
ortCurve = "cubic-bezier(0.26, 0.86, 0.44, 0.985)"

# Customize default animation settings
Framer.Defaults.Animation =  curve: mdCurve, time: .3

# Colours
googleBlue = "#4285f4"
lightBlue = "#84A6EA"



# Content
bundleSettings = [
	{
		title : "No bundles", 
		desc : "<b>No bundles.</b> You like to see every email that comes in, no matter how insignifcant.  No emails will be grouped in the inbox."
	},
	{
		title : "Minimal bundling", 
		desc : "<b>A few bundles.</b> The most common setting.  We bundle all of the cluttery social and promotional mail in your inbox."
	},
	{
		title : "Lots of bundling", 
		desc : "<b>Lots of bundles.</b> You're busy.  You only need to see the stuff that really matters.  We bundle everything except the most important things in your inbox."
	},
	{
		title : "Custom bundling", 
		desc : "<b>Custom setup.</b> You want to make sure your inbox is just how you like it.  Swipe up to configure each bundle the way you want it."
	},
]

# Arrays to push stuff to later.
sliderZones = []
sliderStuds = []

# Making this layer here to make some variables from it.
Screen.backgroundColor = "#ececec"
bg = Screen
## Variables

# Width of each "zone"
zoneWidth = bg.width / bundleSettings.length-1	
pd = 64		# Base padding
currentSetting = 0	# Default setting for the slider.
previousSetting = currentSetting  # We'll use this later.
playing = false

################################################################################
# Layers
################################################################################

# Video layers
video1 = new VideoLayer 
	x:0, y:0, width:750, height:984, video:"images/1to2.mp4", opacity: 1
video1.player.setAttribute('webkit-playsinline', 'true')

video1.player.pause()

video2 = new VideoLayer 
	x:0, y:0, width:750, height:984, video:"images/2to3.mp4"
video2.player.setAttribute('webkit-playsinline', 'true')
video1.placeBefore(video2)
video2.player.pause()
# video2.player.play()
# Card to put everything in.
settingsCard = new Layer
	width: bg.width
	height: 288
	backgroundColor: googleBlue
	shadowY: -4
	shadowBlur: 8
	shadowColor: "rgba(0,0,0,.15)"
settingsCard.y = bg.height

# Title of the card.
cardTitle = new Layer
	superLayer: settingsCard
	x: pd
	y: pd
	height: 48
	width: bg.width -  (pd * 2)
	backgroundColor: ""
cardTitle.html = "Choose how much clutter to bundle"
# cardTitle.style = "font-weight" : "300"
cardTitle.style = lineHeight : "48px"
styleText(cardTitle, 38, "white")

sliderDesc = new Layer
	superLayer: settingsCard
	y: cardTitle.maxY + pd
	height: 48 * 3 
	backgroundColor: ""
	width: bg.width - (pd * 2)
	x: pd
styleText(sliderDesc, 32, "white")
sliderDesc.style = lineHeight : "48px"

slider = new Layer
	height: (32 * 2) + 48
	superLayer: settingsCard
	y: sliderDesc.maxY + pd
	backgroundColor: ""
	width: bg.width
	

# Create the Settings zones and the studs.
for a in [0..bundleSettings.length-1]

	# The boundaries of each setting.
	sliderZone = new Layer
		superLayer: slider
		width: zoneWidth	# 16 added arbitrarily to get things to line up.
		height: slider.height
		backgroundColor: ""
	sliderZone.x = (sliderZone.width * a)	 # 32 added for lining up too.
	
	# Add to an array for later.
	sliderZones.push(sliderZone)
	
	# Make the little studs in the middle of each zone.
	sliderStud = new Layer
		width: 20
		height: 20
		borderRadius: 10
		backgroundColor: lightBlue
		superLayer: sliderZone
	sliderStud.center()
	sliderStud.states.add
		activated: { backgroundColor: "white" }
	# Add those to another array.
	sliderStuds.push(sliderStud)
	
	
#Create the connecting line across the studs.
sliderLine = new Layer
	superLayer: slider
	height: 4
	x: sliderZones[0].midX
	width: sliderZones[sliderZones.length-1].midX - sliderZones[0].midX
	backgroundColor: lightBlue
sliderLine.centerY()

activeSliderLine = new Layer
	superLayer: slider
	height: 4
	x: sliderZones[0].midX
	width: 0
	backgroundColor: "white"
activeSliderLine.centerY()


# THE THUMB.
sliderThumb = new Layer
	superLayer: slider
	width: 80
	height: 80
	borderRadius: 40
	backgroundColor: "white"
	shadowY: 4
	shadowBlur: 8
	shadowColor: "rgba(0,0,0,.2)"
sliderThumb.centerY()

# Make is horizontally draggable.
sliderThumb.draggable.enabled = true
sliderThumb.draggable.speedY = 0
sliderThumb.draggable.speedX = 1

# Make it bigger and raised when you are grabbing it.
sliderThumb.states.add
	grabbed: { scale: 1.2, shadowY: 8, shadowBlur: 16 }



################################################################################
# Interactions
################################################################################

sliderThumb.on Events.DragStart, ->
	sliderThumb.states.switch "grabbed"
	previousSetting = currentSetting
	
sliderThumb.on Events.DragMove, ->
	# Do the initial math to calculate the slider position
	sliderPos = (sliderThumb.frame.x + (sliderThumb.width/2)) / zoneWidth
	
	# Figure out which setting it should be
	getIndex(sliderPos)
	
	for b in [0..sliderStuds.length-1]
		if sliderZones[b].midX <= sliderThumb.midX
			sliderStuds[b].states.switch "activated"
		else
			sliderStuds[b].states.switch "default"
			
	activeSliderLine.width = 
		sliderThumb.midX - sliderZones[0].midX
# 	print currentSetting + " + " + previousSetting
	
		
	
	# Change description
	if currentSetting != previousSetting
		if !playing && currentSetting == 1 && previousSetting == 0
	
			playing = true
	
			video1.placeBefore(video2)
			video1.player.playbackRate = 1
			video1.player.play()
		

		if !playing && currentSetting == 2 && previousSetting == 1
			playing = true
			video1.opacity = 0
			video2.player.playbackRate = 1
			video2.player.play()
		if currentSetting == 3 && previousSetting == 2
			video2.animate
				properties:
					opacity: .3
		if currentSetting == 2 && previousSetting == 3
			video2.animate
				properties:
					opacity: 1
		if !playing && currentSetting == 1 && previousSetting == 2 
			playing = true
	
			video1.opacity = 0
			video2.player.playbackRate = -1.2
			video2.player.play()
			
		if !playing && currentSetting == 0 && previousSetting == 1 
			playing = true
	
			video1.opacity = 1
	
			video1.player.playbackRate = -1.2
			video1.player.play()
		
		previousSetting = currentSetting
		
		sliderDesc.animateStop()
		hideDesc = sliderDesc.animate
			properties:
				opacity: 0
			time: .2
		hideDesc.on Events.AnimationEnd, ->
			sliderDesc.html = bundleSettings[currentSetting].desc
			
			sliderDesc.animate
				properties:
					opacity: 1
				time: .2
				
				

		
sliderThumb.on Events.DragEnd, ->
	
	# Ungrab the thumb.
	sliderThumb.states.switch "default"
	
	# Animate the thumb to be in the right setting.
	sliderThumb.animate
		properties:
			midX: sliderZones[currentSetting].midX
		curve: "spring(300,50,40)"
	activeSliderLine.width = 
		sliderZones[currentSetting].midX - sliderZones[0].midX
		
# 	TODO: Set up the configurator flow.
# 	if currentSetting == bundleSettings.length-1
# 		settingsCard.states.switch "tease"

Utils.interval .2, ->
	playing = false
# Get the selected setting's index.
getIndex = (midX) ->
	# Round DOWN the slider's position to get the setting's index.
	index = Math.floor(midX)
	
	# If it is moved off screen to the left, set it to the first setting.
	if midX < 0
		index = 0
		
	# If it's moved off to the right, set it to the last setting.
	else if midX > bundleSettings.length-1
		index = bundleSettings.length-1
		
	# Set the current Setting to be the index.
	currentSetting = index
	
	
################################################################################
# Initialzation
################################################################################

# Set the height of the card based on the last element.
settingsCard.height = slider.maxY + pd

# Position the card at the bottom of the viewport.
settingsCard.y = bg.height - settingsCard.height

# Set the thumb and description to match the current setting.
sliderThumb.midX = sliderZones[currentSetting].midX
sliderDesc.html = bundleSettings[currentSetting].desc

# video1.player.playbackRate = 1
# video1.player.play()
# Utils.delay( .1, ->
# 	video1.player.pause())



