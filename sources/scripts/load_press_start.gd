extends Polygon2D

onready var press_start = get_node("press_start")
onready var animation = get_node("animation")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func stop():
	animation.stop_all()
	press_start.set_text("Have fun!")
	
func reset():
	animation.play("blink")
	press_start.set_text("Loading...")

func level_ready():
	press_start.set_text("Press any button to Start")