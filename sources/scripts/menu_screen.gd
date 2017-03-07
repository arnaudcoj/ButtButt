extends CanvasLayer

signal pause
signal restart
signal menu
signal next

var enabled = true
var open = false
onready var animation = get_node("animation")
onready var menu_screen = get_node("menu_screen")
onready var buttons = menu_screen.get_node("buttons")


func _ready():
	pass

func open():
	if enabled && !open:
		animation.play("open")
		emit_signal("pause")
		get_tree().set_pause(true)
		menu_screen.reset()
	open = true

func close():
	if open:
		animation.play_backwards("open")
		get_tree().set_pause(false)
		menu_screen.stop()
		for button in buttons.get_children():
			button.release_focus()
		open = false

func set_enabled(enabled):
	self.enabled = enabled

func _on_restart_button_pressed():
	if open:
		emit_signal("restart")
		close()

func _on_resume_button_pressed():
	if open:
		handle_pause()

func _on_menu_button_pressed():
	if open:
		emit_signal("menu")
		close()

func _on_next_button_pressed():
	if open:
		emit_signal("next")
		close()