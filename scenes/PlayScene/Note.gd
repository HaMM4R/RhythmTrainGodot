extends Node2D

signal clicked_note
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var noteID = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(var note_type, id):
	#print("Init note: ", note_type)

	$AnimatedSprite.animation = note_type
	noteID = id
	#var collisionShape = RectangleShape2D.new()
	#collisionShape.extents = Vector2(10,10)
	#$CollisionArea/CollisionShape.shape = collisionShape
				
	match $AnimatedSprite.animation:
		"quarter":
			$AnimatedSprite.offset = (Vector2(0,-45))
		"half":
			$AnimatedSprite.offset = (Vector2(0,-45))
		"eighth":
			$AnimatedSprite.offset = (Vector2(0,-45))
	
	#print("Final note: ",$AnimatedSprite.animation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Checks to see if the mouse is in the collison object when clicked
func _on_CollisionArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		emit_signal("clicked_note") 
