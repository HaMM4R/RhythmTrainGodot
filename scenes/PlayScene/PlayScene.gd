extends Node2D

# Packed scenes for adding to the main scene
export (PackedScene) var Note
export (PackedScene) var Bar
export (PackedScene) var Pointer

# These could all be refactored!

var playing = false

# Variables for storing the active nodes
var pointer_node

# These are't really used (yet?)
var note_nodes = []
var bar_nodes = []

# stores bpm
# TODO read this from file 
var bpm = 85.0

# stores distance for pointer to move per phys proc
# maybe move to function 
var distToTravel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Open Json file and read as text
	var file = File.new()
	file.open("res://assets/json/randomBeats.json", File.READ)
	var text = file.get_as_text()
	file.close()
	
	# Parse Json
	var music_json = JSON.parse(text).result

	place_notes(music_json)
	
# Function to place 2 bars with notes on the scene
func place_notes(notes):
	# Initial positions for bars/notes
	# TODO make placement nicer + make some more variables for it
	var posx = 100
	var posy = 200
	
	# Create the initial bar node and position it
	var bar_node_init = Bar.instance()
	add_child(bar_node_init)
	bar_node_init.position = Vector2(posx,posy)
	
	# Increase the x value for nicer note placement, so it doesn't just get
	# stuck in the stave
	
	# TODO: CHANGE INITIAL PLACING TO BE RELATIVE RATHER THAN JUST LINEAR
	
	# Counter for counting the current notes
	var totalTime = 0
	
	# For each note in each Random Bar 
	for bar in notes["RandomBars"]:
		for note in bar["notes"]:
			
			
			var time = note["time"]
			var note_type
			
			# Selecting note type
			
			match time:
				0.25:
					note_type = "quarter"
				0.125:
					note_type = "eighth"
				0.5: 
					note_type = "half"
				1:
					note_type = "whole"
			
			
			totalTime += time
			 
			# Increment note counter
			#currentNote+=1
		
			
			
			
			# TODO:
			# MAYBE PUT THIS IN A FUNCTION?
			if totalTime > 1:
				# Increment bar position on y + reset x position
				posy+= 150 
				posx = 100
				
				# Create bar instance
				var bar_node = Bar.instance()
				add_child(bar_node)
				bar_node.position = Vector2(posx,posy)
				#currentNote = 0
				totalTime = 0
			
			# Create note instance
			# TODO: ADD NOTES TO NOTE ARRAY/DICT SO NOTES ARE TRACKABLE
			var note_node = Note.instance()
			add_child(note_node)
			note_node.init(note_type)
			
			
			var placementX = posx + 40
			print((360*time)/2)
			print(placementX)
			note_node.position = Vector2(placementX,posy)
			posx+=360*time

# Play the notes
# TODO
# WILL NEED TO ADD BARS TO AN ARRAY/DICT MAYBE?
func play_notes():
	# New pointer instance
	print("Beats per minute:",bpm)
	var beatsPerSecond = (bpm/60.0)
	print("Beats per second:",beatsPerSecond)
	var lengthOfBar = (1/beatsPerSecond)*4
	print(lengthOfBar)
	distToTravel = (360/lengthOfBar)/60
		
	pointer_node = Pointer.instance()
	add_child(pointer_node)
	pointer_node.position = Vector2(140, 80)
	playing = true
	$MusicPlayer.play()


# Called every PHYSICS process
# Roughly 60 times a second
# TODO make the pointer reset to the start
func _physics_process(_delta):
	if playing:
		# Increase pointer pos 		
		pointer_node.translate(Vector2(distToTravel,0))
		var curPos = pointer_node.position 
		
		# If reached the end of a bar, move to next bar
		# TODO: MAKE THIS RELATIVE TO BAR POSITION + LENGTH
		if curPos.x > (100 + 360):
			pointer_node.position = Vector2(100, 230)

# Signal signal to start song
# TODO switch this to when scene is entered
func _on_GUI_start_song():
	play_notes()


func _on_GUI_start_countdown():
	$GUI.song_countdown(bpm)


func _on_GUI_sound_metronome():
	$MetronomeSound.play()
