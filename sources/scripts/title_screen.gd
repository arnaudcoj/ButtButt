extends CanvasLayer

signal opened
signal closed

onready var top_screen = get_node("top_screen")
onready var bottom_screen = get_node("bottom_screen")
onready var animation = get_node("animation")

var open = false

func _ready():
	pass
	
func play_split():
	animation.play("split")

func is_ready():
	return !animation.is_playing()
	
func level_ready():
	get_node("bottom_screen").level_ready()
	
func _on_animation_finished():
	if get_node("animation").get_current_animation() == "split":
		open = !open
		if open:
			top_screen.stop()
			bottom_screen.stop()
			emit_signal("opened")
		else:
			emit_signal("closed")
		
func reset():
	animation.play_backwards("split")
	top_screen.reset()
	bottom_screen.reset()
	