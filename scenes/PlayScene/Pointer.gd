extends Node2D

signal Pointer_area_entered


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	print("Entered note")
	var noteFound = area.get_parent()
	noteFound.get_node("AnimatedSprite").modulate = Color(1,0,0)

func _on_Area2D_area_exited(area):
	print("Exited note")
	
