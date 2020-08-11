extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(var note_type):
	print("Init note: ", note_type)
	
	$AnimatedSprite.animation = note_type
	
	var collisionShape = RectangleShape2D.new()
	
	collisionShape.extents = Vector2(45,45)
	$CollisionArea/CollisionShape.shape = collisionShape
				
	match $AnimatedSprite.animation:
		"quarter":
			$AnimatedSprite.offset = (Vector2(0,-45))
		"half":
			$AnimatedSprite.offset = (Vector2(0,-45))
		"eighth":
			$AnimatedSprite.offset = (Vector2(0,-45))
	
	print("Final note: ",$AnimatedSprite.animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
