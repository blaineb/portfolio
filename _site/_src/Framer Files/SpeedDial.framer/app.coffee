################################################################################
# Content
################################################################################
Framer.Device.customize
	deviceType: Framer.Device.Type.Phone
	screenWidth: 750
	screenHeight: 1334
	deviceImage: "images/iphone-white.png"
	deviceImageWidth: 990
	deviceImageHeight: 1982

speedDialContent = [
	{ label: "Compose", image: "images/ic_add_white_2x_web_24dp.png", otherimage: "images/ic_mode_edit_white_2x_web_24dp.png" },
	{ label: "Remind me to...", image: "images/ic_reminder_white_2x_web_24dp.png" },
	{ label: "Blaine Billingsley", image: "images/blaine-big.png" },
	{ label: "Roy Shin", image: "images/roy-big.png" },
	{ label: "Gill Ward", image: "images/gill-big.png" },
]
Canvas.backgroundColor = "#f9f9f9"
speedDials = []
speedDialLabels = []


################################################################################
# Setup and variables
################################################################################
bg = new Layer 
	backgroundColor: "#ececec"     #The stage
	width: Screen.width
	height: Screen.height
mdCurve = "cubic-bezier(0.4, 0.0, 0.2, 1)"     #Material Design Animation Curves
Framer.Defaults.Animation = curve: mdCurve, time: .3    #Customize defaults

# Specific to this prototype
miniFabSize = 96
speedDialOpen = false
speedDialLabelStyle =	# For some text length hackery later.
	"font" : "28px/64px Roboto"
	"color" : "#999"
	
# Find the label width for each piece of content.  This is the hackery.
for b in [0..speedDialContent.length-1]	
	labelWidth = Utils.textSize(speedDialContent[b].label, speedDialLabelStyle).width
	speedDialContent[b].width = labelWidth
# 	print speedDialContent[b].width



################################################################################
# Layers
################################################################################

appBar = new Layer
	height: 112 + 42
	width: bg.width
	backgroundColor :"#4285f4"
appBar.style.boxShadow = "0 0 8px rgba(0,0,0,.14), 0 4px 8px rgba(0,0,0,.2)"
nav = new Layer
	width: 1500/2
	height: 304/2
	parent: appBar
	image: "images/nav.png"
tlCard = new Layer
	height: bg.height
	width: bg.width
	y: appBar.maxY
	borderRadius: 4
	backgroundColor: ''
# tlCard.style.boxShadow = "0 0 2px rgba(0,0,0,.15), 0 1px 2px rgba(0,0,0,.15)"
content = new Layer
	width: 1500/2
	parent: tlCard
	height: 2098/2
	image: "images/content.png"

# SPEED DIAL BEGINS!!!

speedDialScrim = new Layer
	width: bg.width
	height: bg.height
	backgroundColor: "#ececec"
	opacity: 0
speedDialScrim.states.add
	shown: {opacity: .8 }
	
	
# Make the Speed Dial.
[0..speedDialContent.length-1].map (i) ->
	
	# Compose FAB.
	if i == 0	
		FAB = new Layer
			height: 112
			width: 112
			borderRadius: 56
			backgroundColor: "#db4437"
			x: bg.width - 112 - 32
			y: bg.height - 112 - 32
		
	# All the little guys.
	else
		FAB = new Layer
			height: miniFabSize
			width: miniFabSize
			borderRadius: miniFabSize / 2
			backgroundColor: "#4285f4"
			x: bg.width - miniFabSize - 32 - ((112 - miniFabSize) / 2)
			y: (bg.height - 112 - 32 - ((miniFabSize + 32) * i))
			scale: .8
			opacity: 0
			
		if i > 1
			FAB.image = speedDialContent[i].image
			
		FAB.states.add
			shown: { opacity: 1, y: bg.height - 112 - 32 - ((miniFabSize + 32) * i), scale: 1 }
		
		# Add avatars to the non-system ones.
		
	
	FAB.style.boxShadow = "0 0 8px rgba(0,0,0,.14), 0 4px 8px rgba(0,0,0,.28)"
	speedDials.push(FAB) # Add them all to an array for later.
	
	# Labels 
	speedDialLabel = new Layer
		height: 64
		backgroundColor: "rgba(255,255,255,.9)"
		borderRadius: 8
		width: speedDialContent[i].width + 32
		maxX: FAB.x - 32
		midY: FAB.midY
		opacity: 0

	# For some reason Framer blows up if you try to use the variable here.
	# TODO sort that out.
	speedDialLabel.style =
		"font" : "28px/64px Roboto"
		"color" : "#999"
		"text-indent" : "16px"
	speedDialLabel.html = speedDialContent[i].label

	speedDialLabel.states.add
		shown: { opacity: 1 }
	
	speedDialLabel.style.boxShadow = "0 0 4px rgba(0,0,0,.14), 0 2px 4px rgba(0,0,0,.28)"
	speedDialLabels.push(speedDialLabel) # Add them all to an array for later.
# / End loop.			

# Icons	
ic_reminder = new Layer
	parent: speedDials[1]
	width: 48
	height: 48
	image: speedDialContent[1].image
ic_reminder.center()


ic_add = new Layer
	x:0, y:0, width:48, height:48, image: speedDialContent[0].image, parent: speedDials[0]
ic_add.center()
ic_add.states.add
	hidden: { opacity: 0, rotation: 135 }
	
	
ic_create = new Layer
	x:0, y:0, width:48, height:48, image: speedDialContent[0].otherimage, rotation: -135, opacity: 0, parent: speedDials[0]
ic_create.center()
ic_create.states.add
	shown: { opacity: 1, rotation: 0 }




################################################################################
# Interactions
################################################################################

speedDials[0].on Events.Click, ->
	if !speedDialOpen	# If it's closed, open it.
		openSpeedDial()
	else
		closeSpeedDial()
		# TODO - Compose New Message interaction
	speedDialOpen = !speedDialOpen # Flip the boolean

# Close it when tapping anywhere else
speedDialScrim.on Events.Click, ->
	closeSpeedDial()
	speedDialOpen = false


openSpeedDial = ->
	ic_add.states.switch "hidden"
	ic_create.states.switch "shown"
	speedDialScrim.states.switch "shown"
	
	for a in [1..speedDials.length-1]
		speedDials[a].states.animationOptions = { delay:  a * .03 }
		speedDials[a].states.switch "shown"
		
	for c in [0..speedDialLabels.length-1]
		speedDialLabels[c].states.animationOptions = { delay:  a * .01 }
		speedDialLabels[c].states.switch "shown"
		
		
closeSpeedDial = ->
	ic_add.states.switch "default"
	ic_create.states.switch "default"
	speedDialScrim.states.switch "default"
	for a in [1..speedDials.length-1]
		speedDials[a].states.animationOptions = { delay:  (speedDials.length - a) * .03 }
		speedDials[a].states.switch "default"
	
	for c in [0..speedDialLabels.length-1]
		speedDialLabels[c].states.animationOptions = { delay:  (speedDialLabels.length - c) * .03 }
		speedDialLabels[c].states.switch "default"
	

