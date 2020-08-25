extends Node2D

signal Pointer_area_entered
signal note_entered
signal note_exited

var noteIsHit
# Declare member variables here. Examples:
# var a = 2 
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
#	pass

var currentNote

func _on_Area2D_area_entered(area):
	print("Entered note")
	emit_signal("note_entered")
	currentNote = area
	

func _on_Area2D_area_exited(area):
	print("Exited note")
	emit_signal("note_exited")
	 
	var noteFound = area.get_parent()
	# If the note wasn't hit, turn it red
	if !noteIsHit:
		noteFound.get_node("AnimatedSprite").modulate = Color(1,0,0)
	noteIsHit = false
		
func noteHit():
	# When the note is hit, turn the note G r e e n
	var noteFound = currentNote.get_parent()
	noteFound.get_node("AnimatedSprite").modulate = Color(0,1,0)
	noteIsHit = true
	
