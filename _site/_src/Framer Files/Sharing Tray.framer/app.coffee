# Material Design Animation Curves
mdCurve = "cubic-bezier(0.4, 0.0, 0.2, 1)"
mdCurveIn = "cubic-bezier(0.0, 0.0, 0.2, 1)"
mdCurveOut = "cubic-bezier(0.4, 0.0, 1, 1)"

# Customize default animation settings
Framer.Defaults.Animation =   
	curve: "spring(200, 20, 0)"


# Remove framer cursor
document.body.style.cursor.scale = .5
 
bg = new BackgroundLayer backgroundColor: "white"
# Phone Setup
pager1Content = ["images/pager1-1.png","images/pager1-2.png","images/pager1-3.png","images/pager1-4.png","images/pager1-5.png","images/pager1-6.png"]
pager2Content = ["images/pager2-1.png"
,"images/pager2-2.png","images/pager2-3.png","images/pager2-4.png"
,"images/pager2-5.png", "images/pager2-6.png"]
phone = new Layer 
	backgroundColor: "white"
	width: 360
	height: 1280/2
	clip: true
	style: "box-shadow" : "0 0 4px rgba(0,0,0,.2)"
phone.center()
phoneShadow = new Layer
	width: phone.width - 64
	maxY: phone.maxY
	height: phone.height / 2
	x: Align.center()
	style: 
		"box-shadow" : "0 0 40px rgba(0,0,0,.7)"
phoneShadow.placeBehind(phone)

statusBar = new Layer
	width: 360, height: 24
	image: "images/Status Bar.png"
	superLayer: phone
controls = new Layer
	width: 360, height: 54
	image: "images/Navigation Bar.png"
	superLayer: phone
	y: phone.height - 54
canvas = new Layer
	width: 360, height: 1142/2
	image: "images/Canvas.png"
	superLayer: phone
	y:  24
keyboard = new Layer
	width: 360, height: 269
	image: "images/keyboard.png"
	superLayer: phone
	y: phone.height - 269 - 48
keyboard.states.add
	hidden:
		y: phone.height

trayWrapper = new ScrollComponent
	width: phone.width, height: canvas.height
	y: 24
	scrollHorizontal: false
	directionLock: true
	contentInset: 
		top: 298
# 	backgroundColor: "rgba(0,0,0,0.2)"
	superLayer: phone
# shim = new Layer
# 	height: 200
# 	superLayer: trayWrapper.content
# 	width: phone.width
trayFake = new Layer
	width: 360, height: 1621/2
	image: "images/tray.png"
	superLayer: trayWrapper.content
	y: 0

pager1 = new PageComponent
	width: phone.width
	height: 96
	superLayer: trayFake
	y: 56
	directionLock: true
	scrollVertical: false
	contentInset:
		left: 16
for i in [0...pager1Content.length-1]
	chip = new Layer
		width: 132
		height: 88
		superLayer: pager1.content
		x: (140 * i)
		originX: 1
		borderRadius: 2
		shadowY: 1
		shadowBlur: 2
		shadowColor: "rgba(0,0,0,.2)"
		image: pager1Content[i]
	chip.centerY()
	
pager2 = new PageComponent
	width: phone.width
	height: 96
	superLayer: trayFake
	y: 372
	directionLock: true
	scrollVertical: false
	contentInset:
		left: 16
for i in [0...pager2Content.length-1]
	chip = new Layer
		width: 132
		height: 88
		superLayer: pager2.content
		x: (140 * i)
		originX: 1
		borderRadius: 2
		shadowY: 1
		shadowBlur: 2
		shadowColor: "rgba(0,0,0,.2)"
		image: pager2Content[i]
	
	chip.centerY()

# Create 10 pages
# for i in [0..10]
# 	layerA = new Layer
# 		width: 180, height: 180
# 		x: (190 * i) + 10
# 		borderRadius: 4
# 		backgroundColor: "#fff"
# 		superLayer: trayWrapper.content 

canvas.on Events.Click, ->
	trayWrapper.placeBehind(keyboard)
	keyboard.states.switch "hidden"
	


trayWrapper.on Events.ScrollEnd, ->
# 	print trayWrapper.direction
	if trayWrapper.scrollY < 300 and trayWrapper.direction == "down"
		trayWrapper.animate
			properties:
				scrollY: 300

trayWrapper.sendToBack()
keyboard.bringToFront()
statusBar.bringToFront()
controls.bringToFront()



