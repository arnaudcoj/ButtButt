extends Control

signal start

func _ready():
	set_process_input(true)
	
func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON || event.type == InputEvent.SCREEN_TOUCH || event.type == InputEvent.KEY) && !event.pressed:
		emit_signal("start")
