# SETUP

jrdSpring = "spring(500, 50, 10)"
Framer.Defaults.Animation = curve: jrdSpring

# Content
columnContent = [ "A", "B", "C", "D" ] # TODO: Add column headers
tileContent = 10 # TODO: Add tile content

# Metrics
colWidth = 100
tileHeight = 64
colGutter = 48
pd = 8
laneWidth = colWidth + (pd * 2)

bgColor = new Color("#1F6764").lighten(20)
# Arrays
columnArrays = [] #Array of arrays
swimlanes = []	# The container layers
startCol = null	# We'll set this later
startIndex = null # Later...
currentCol = null # You guessed it...

# Functions
closestIndex = (number, array) ->
	current = 0 
	for each, a in array
		if Math.abs(number - each) < Math.abs(number - array[current])
			current = a
	return current
# Finds the number in an array that's closest to another value, and 
# returns the index.
updateIndex = (layer, array) ->
	# Make an array of all midY values.
	midYs = array.map (i) -> i.midY
	
	# Going higher up the list
	if midYs[startIndex] <= midYs[startIndex-1]
		array.splice(startIndex,1)
		array.splice(startIndex-1, 0, layer)
		startIndex = array.indexOf(layer)
		sortVertically(array)
	
	# Going lower down the list
	else if midYs[startIndex] >= midYs[startIndex+1]
		array.splice(startIndex,1)
		array.splice(startIndex+1, 0, layer)
		startIndex = array.indexOf(layer)
		sortVertically(array)
# Updates the vertical index of the the layer and
# resorts as needed.
# TODO: Write this out a little more elegantly.
sizeSwimLane = (index) ->
	# Chill out on the animating.
	swimlanes[index].animateStop()
	
	# Set a height value based on how many tiles there are
	heightVal = pd + ((tileHeight + pd) * (columnArrays[index].length))
	
	# Set a minimum height if that value was too low
	if heightVal < 200 then heightVal = 200
	
	# Animate the height to that value.
	swimlanes[index].animate properties:
		height: heightVal
# Resize the container to fit all the tiles.
sortVertically = (array) ->
	# Go through the array...
	for tile, t in array	
		# Chill out on animating.
		tile.animateStop()
		# As long as it's not the dragging element...
		if tile.draggable.isDragging is false
			# Animate it.
			tile.animate properties:
				y: 8 + (tileHeight + pd) * t
# Animate tiles into position.
changeCol = (layer, yVal) ->
	# Remove it from it's current column
	columnArrays[startCol].splice(startIndex, 1)
	
	# Add it to it's new column
	columnArrays[currentCol].splice(yVal, 0, layer)
	
	# Reset the start column to the new one
	startCol = currentCol
# Change which column a dragged tile is in.

# Layers
# LAYERS
bg = new BackgroundLayer backgroundColor: bgColor

container = new Layer
	# Set a width based on the content
	width: (laneWidth * columnContent.length) + (colGutter * (columnContent.length-1))
	x: Align.center
	y: Align.center
	height: bg.height - 48
	backgroundColor: ""

# Make the columns from the column content array
for list, i in columnContent
	# Vertical tracks....
	swimlane = new Layer
		width: laneWidth
		borderRadius: 6
		height: 200
		parent: container
		x: (laneWidth * i) + (colGutter * i)
		backgroundColor: bgColor.darken(7)
	
	# Add to the array for further manipulation later.
	swimlanes.push swimlane
	
	# Make an array
	arr = []
	# Add the array to a bigger array (meta o_O)
	columnArrays.push arr

# Create midX arrays from swimlines
# We'll use this to determine which column a dragged tile is closest to.
midXs = swimlanes.map (i) -> i.midX
# TILES AND INTERACTIONS
for tile in [0..tileContent]

	# Put each tile in a random place
	randoCol = Utils.round(Utils.randomNumber(0, swimlanes.length-1), 0)
	
	# Create the tile
	tile = new Layer
		width: colWidth
		height: tileHeight
		borderRadius: 4
		color: "#999"
		backgroundColor: "white"
		parent: container
		x: swimlanes[randoCol].x + pd
		shadowY: 1
		shadowBlur: 2
		shadowColor: "rgba(0,0,0,.1)"
	
	# Add it to the array (which is in another array o_O)
	columnArrays[randoCol].push(tile)
	
	#Now that it's part of the array, set the y value for it based on the array.
	tile.y = 8 + (tileHeight + pd) * (columnArrays[randoCol].length-1)
	
	# Make it draggable.
	tile.draggable.enabled = true
	
	# Size the swimlane appropriately for how many tiles there are
	heightVal = columnArrays[randoCol][columnArrays[randoCol].length-1].maxY + pd
	
	# Conditionally set a minimum height
	# TODO: Wrap this up better with the function.
	if heightVal < 200 then heightVal = 200
	
	# Set the height.
	swimlanes[randoCol].height = heightVal
	
	
	##################################################
	# INTERACTIONS
	##################################################

	tile.on Events.TouchStart, (event, layer) ->
		# Record the column it's in at the begging to startCol.
		startCol = closestIndex(@.midX, midXs)
		
		# set the currentCol to the startCol.
		currentCol = startCol
		
		# get it's index.  This should actually be called currentIndex
		# because we're going to update it throughout
		startIndex = columnArrays[startCol].indexOf(@)
		
		# Bring it to the front of all layers.
		@.bringToFront()
		
		# Animate to a dragging state!
		@.animate
			properties:
				scale: 1.1
				shadowY: 4
				shadowBlur: 8
				shadowColor: "rgba(0,0,0,.2)"
		
	
	tile.on Events.DragMove, (event, layer) ->
		
		# Update vertical indices
		updateIndex(@, columnArrays[startCol])
		
		# Figure out which column it should be in based on midXs
		currentCol = closestIndex(layer.midX, midXs)
		
		# If it's moved to a different column from where it was...
		if currentCol != startCol
			
			# Remove it from it's current column
			columnArrays[startCol].splice(startIndex, 1)
			
			# Add it to it's new column, keeping the same index it's at.
			columnArrays[currentCol].splice(startIndex, 0, layer)
			
			# Re-sort the tiles now that they've changed
			sortVertically(columnArrays[currentCol])
			sortVertically(columnArrays[startCol])
			
			# Resize the swimlane containers
			sizeSwimLane(startCol)
			sizeSwimLane(currentCol)
			
			# Set the startCol to the currentOne so the fun
			# can begin again!
			startCol = currentCol


	tile.on Events.DragEnd, (event, layer) ->
		# Animate the dragged layer back into place
		@.animate properties:
			y: 8 + (tileHeight + pd) * (columnArrays[currentCol].indexOf(@))
			x: swimlanes[currentCol].x + pd
			scale: 1
			shadowY: 1
			shadowBlur: 1
			shadowColor: "rgba(0,0,0,.1)"
			
# 	Do the same thing on mouseUp so single clicks don't jack it up.
	tile.on Events.TouchEnd, (event, layer) ->
# 		Animate the dragged layer back into place
		@.animate properties:
			y: 8 + (tileHeight + pd) * (columnArrays[currentCol].indexOf(@))
			x: swimlanes[currentCol].x + pd
			scale: 1
			shadowY: 1
			shadowBlur: 1
			shadowColor: "rgba(0,0,0,.1)"
