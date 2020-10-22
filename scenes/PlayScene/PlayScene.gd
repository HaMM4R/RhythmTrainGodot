extends Node2D

# Packed scenes for adding to the main scene
export (PackedScene) var Note
export (PackedScene) var Bar

var playing = false

# Variables for storing the active nodes

var note_nodes = []

# stores bpm
# TODO read this from a beats file 
# TODO make a beats file!
var bpm = 85.0

# stores distance for pointer to move per phys process
# maybe move to function 
var distToTravel = 0

# stores score/streak
var score = 0
var streak = 0

# getting the current note
var curNote = 0
var noteClicked

# stores the data loaded from the json file
var music_json

# Called when the node enters the scene tree for the first time.
func _ready():
	# Open Json file and read as text
	var file = File.new()
	file.open("res://assets/json/randomBeats.json", File.READ)
	var text = file.get_as_text()
	file.close()
	
	# Parse text as Json
	music_json = JSON.parse(text).result
	
	# Place bars on the scene
	place_bars()
	
	# Place notes on the scene w Json
	place_notes(music_json)
	
	
# Funciton to remove notes from scene
func remove_notes():
	# For each note on screen, remove from the scene
	for note in note_nodes:
		note.queue_free()
		
	# Clear the note array to make way for new notes
	note_nodes.clear()
	

# Function to place 3 bars with notes on the scene
func place_bars():
	# Initial PosX/Y
	var posx = 100
	var posy = 200
	
	# Create each bar
	for n in range(3):
		# Create bar instances and add to scenes
		var bar_node = Bar.instance()
		add_child(bar_node)
		bar_node.position = Vector2(posx,posy)
		
		# Increment position
		posy+= 250 
		
		
# Function to place notes on screen
func place_notes(bars):
	# TODO placement is a bit weird atm, maybe refactor it
	
	# Initial positions for bars/notes
	var posx = 100
	var posy = 200
	var index = 0
	
	# Counter for counting the current notes
	var totalTime = 0
	
	#Reset the current note ready for new bar set
	curNote = 0
	
	# - Bar selection -
	
	# Stores the randomly selected bars
	var selectedBars = []
	
	# Select a random bar 3 times
	for n in range(3):
		#print(bars["RandomBars"].size())
		
		# Get random int corresponding to the number of bars in the Json file 
		randomize()
		var selectedBar = randi()%bars["RandomBars"].size()
		
		# Add random bar to list
		selectedBars.append(bars["RandomBars"][selectedBar])
		
	
	# For each note in each Random Bar 
	for bar in selectedBars:
		for note in bar["notes"]:
			# stores the time value of the note
			var time = note["time"]

			# stores the type of note
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
			
			# Create note instance
			index += 1
			var note_node = Note.instance()
			note_node.init(note_type, index)
			note_nodes.append(note_node)
			add_child(note_node)
			
			
			
			# TODO MAYBE PUT THIS IN A FUNCTION?

			
			# If the total duration of the notes in the bar more than one
			if totalTime >= 1:
				# TODO maybe make a variable or a way to pass this?
				# Increment y position to match up with bars
				posy+= 250 
				
				# Reset x position
				posx = 100

				# Reset time
				totalTime = 0
			
			
			# Increment the bar's total time with the note's length
			totalTime += time
			
			# Set placement of note
			var placementX = posx + 40
			note_node.position = Vector2(placementX,posy)
			posx+=360*time



# Play the notes
func play_notes():
	
	#print("Beats per minute:",bpm)
	var beatsPerSecond = (bpm/60.0)
	#print("Beats per second:",beatsPerSecond)
	var lengthOfBar = (1/beatsPerSecond)*4
	#print(lengthOfBar)
	distToTravel = (360/lengthOfBar)/60
		
	# Start Pointer
	# TODO This current code sets the pointer to the first note of the first bar
	# What would be nice is for the pointer to run a long an initial bar during
	# the countdown 
	
	$Pointer.position = Vector2(140, 80)
	playing = true
	$MusicPlayer.play()




# Stores which bar the pointer is on
var barCount = 1

# Called every physics process
# Roughly 60 times a second
# This is used instead of process to ensure the frame rate does no interfere 
# with the music timing
func _physics_process(_delta):
	if playing:
		# Increase pointer pos 		
		$Pointer.translate(Vector2(distToTravel,0))
		var curPos = $Pointer.position 
		
		# If reached the end of a bar, move to next bar
		# TODO: MAKE THIS RELATIVE TO BAR POSITION + LENGTH
		if curPos.x > (100 + 360):
			if barCount == 3:
				$Pointer.position = Vector2(100, 80)
				barCount = 1
				remove_notes()
				place_notes(music_json)
			else:
				$Pointer.position = Vector2(100, (curPos.y+250))
				barCount += 1

# Signal signal to start song
# TODO switch this to when scene is entered
func _on_GUI_start_song():
	play_notes()


# Sets the speed for the countdown at the start
func _on_GUI_start_countdown():
	$GUI.song_countdown(bpm)

# Plays metronome sound
func _on_GUI_sound_metronome():
	$MetronomeSound.play()


# Stores whether the pointer is colliding with a note node
var inNote

# Stores where the note is clicked
var clickedNote = false

#Check for note hit
func note_hit():
	if inNote and !clickedNote:
		clickedNote = true
		# Increment score
		score += 1
		streak += 1
		$GUI.update_score(score)
		$GUI.update_streak(streak)
		$Pointer.noteHit()
	else:
		#Reset score if clicked at the wrong time
		streak = 0
		$GUI.update_score(score)
		$GUI.update_streak(streak)


# Fucntion for when pointer enters note
func _on_Pointer_note_entered():
	# Flagging if inside note
	inNote = true
	# Sets the current note in the bar and checks for clicks
	note_nodes[curNote].connect("clicked_note", self, "note_area_clicked")
	curNote += 1
	

# Function for when pointer exits note
# If a the note is missed, the streak is reset
func _on_Pointer_note_exited():
	inNote = false
	if !clickedNote:
		streak = 0
		$GUI.update_streak(streak)
	clickedNote = false

	
#Checks to see if you have clicked on a note head
func note_area_clicked(id):
	if(id == curNote):
		note_hit()

