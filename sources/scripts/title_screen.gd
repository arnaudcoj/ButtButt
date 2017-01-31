extends CanvasLayer

onready var top_screen = get_node("top_screen")
onready var bottom_screen = get_node("bottom_screen")
onready var animation = get_node("animation")

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
		top_screen.stop()
		bottom_screen.stop()
		
func reset():
	animation.play("start")
	top_screen.reset()
	bottom_screen.reset()
	