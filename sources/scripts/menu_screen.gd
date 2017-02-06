extends CanvasLayer

signal pause
signal restart
signal menu

var enabled = true
var open = false
onready var animation = get_node("animation")
onready var button = get_node("pause_button")
onready var menu_screen = get_node("menu_screen")
onready var buttons = menu_screen.get_node("buttons")


func _ready():
	set_process_input(true)

func _input(event):
	if !open && event.is_action_released("start"):
		handle_pause()


func set_enabled(enabled):
	self.enabled = enabled
	menu_screen.set_hidden(!enabled)
	button.set_hidden(!enabled)

func _on_animation_finished():
	if animation.get_current_animation() == "open":
		open = !open

func handle_pause():
	if !animation.is_playing():
		if !open:
			buttons.get_node("resume_button").grab_focus()
			animation.play("open")
			emit_signal("pause")
			get_tree().set_pause(true)
			menu_screen.reset()
		else:
			animation.play_backwards("open")
			get_tree().set_pause(false)
			menu_screen.stop()

func _on_pause_button_released():
	if !open:
		handle_pause()

func _on_restart_button_pressed():
	if open:
		emit_signal("restart")

func _on_resume_button_pressed():
	if open:
		handle_pause()

func _on_menu_button_pressed():
	if open:
		emit_signal("menu")
