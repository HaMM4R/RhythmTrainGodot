extends Light2D

export var pulseDuration: = 1.0
onready var light: = get_node(".")
onready var audioVisualiser = get_node("AudioTest/visualiser")

var increasing: = false
var pulseReduce: = false

func _ready():
	light.energy = 0.0


func _physics_process(delta):
	var total = 0
	var mean = 0 
	
	for i in range(70):
		total += audioVisualiser.histogram[i]
		
	mean = total / 70
	light.energy = mean * 5
	

func _test():
	yield(get_tree().create_timer(0.4), "timeout")
	light.energy = 0
