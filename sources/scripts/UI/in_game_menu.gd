extends "res://scripts/UI/menu_screen.gd"

onready var button = get_node("pause_button")

func _ready():
	set_process_input(true)

func set_enabled(enabled):
	.set_enabled(enabled)
	button.set_hidden(!enabled)

func _input(event):
	if enabled && !open && event.is_action_released("start"):
		handle_pause()
		buttons.get_node("resume_button").grab_focus()

func _on_pause_button_released():
	if !open:
		handle_pause()
		
func handle_pause():
	if !animation.is_playing():
		if !open:
			open()
		else:
			close()
