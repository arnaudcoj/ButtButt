extends "res://scripts/UI/menu_screen.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var using_keyboard = false

func _ready():
	set_process_input(true)
	
func close():
	.close()
	using_keyboard = false
	
func _input(event):
	if !using_keyboard && event.type == InputEvent.KEY && open:
		if event.is_action_pressed("move_right") || event.is_action_pressed("start"):
			buttons.get_node("restart_button").grab_focus()
			using_keyboard = true
		elif event.is_action_pressed("move_left"):
			buttons.get_node("menu_button").grab_focus()
			using_keyboard = true

