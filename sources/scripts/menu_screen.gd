extends CanvasLayer

var enabled = true
var open = false
onready var animation = get_node("animation")
onready var button = get_node("pause_button")
onready var menu_screen = get_node("menu_screen")
onready var button_group = menu_screen.get_node("button_group")

const RESTART_BUTTON = 0
const RESUME_BUTTON = 1

func _ready():
	set_process_input(true)

func _input(event):
	if !open && event.is_action_pressed("start"):
		handle_pause()
	elif open:
		if event.is_action_pressed("ui_right"):
			button_group.set_selected(min(button_group.get_button_count() -1, button_group.get_selected() + 1))
		elif event.is_action_pressed("ui_left"):
			button_group.set_selected(max(0, button_group.get_selected() - 1))
		elif event.is_action_released("start"):
			_on_button_group_button_selected(button_group.get_selected())

func set_enabled(enabled):
	self.enabled = enabled
	menu_screen.set_hidden(!enabled)
	button.set_hidden(!enabled)

func _on_animation_finished():
	if animation.get_current_animation() == "open":
		open = !open

func _on_pause_button_pressed():
	if !open:
		handle_pause()

func handle_pause():
	if !animation.is_playing():
		if !open:
			animation.play("open")
			get_parent().get_node("tilemaps/objects/player").release_controls()
			get_tree().set_pause(true)
		else:
			animation.play_backwards("open")
			get_tree().set_pause(false)

func _on_restart_button_pressed():
	if open:
		print("restart")
		get_tree().get_root().get_node("root").restart()

func _on_resume_button_pressed():
	if open:
		print("resume")
		handle_pause()

func _on_button_group_button_selected( button_idx ):
	if button_idx == RESTART_BUTTON:
		_on_restart_button_pressed()
	elif button_idx == RESUME_BUTTON:
		_on_resume_button_pressed()
