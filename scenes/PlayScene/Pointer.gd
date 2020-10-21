extends Node2D

# Singals to tell main loop when pointer enters/leaves notes
signal Pointer_area_entered
signal note_entered
signal note_exited

var noteIsHit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass

var currentNote

# Triggered when pointer enters another area
func _on_Area2D_area_entered(area):
	#print("Entered note")
	emit_signal("note_entered")
	currentNote = area
	
# Triggered when pointer leaves another area
func _on_Area2D_area_exited(area):
	#print("Exited note")
	emit_signal("note_exited")
	 
	var noteFound = area.get_parent()
	# If the note wasn't hit, turn it red
	if !noteIsHit:
		noteFound.get_node("AnimatedSprite").modulate = Color(0.5,0,0)
	noteIsHit = false
		

func noteHit():
	# When the note is hit, turn the note G r e e n
	var noteFound = currentNote.get_parent()
	noteFound.get_node("AnimatedSprite").modulate = Color(0,1,0, 0.5)
	#noteFound.get_node("Particles2D").emitting = true
	noteIsHit = true
	$Particles2D.emitting = true
	
