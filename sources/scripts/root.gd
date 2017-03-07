extends Node

onready var level = get_node("level")
onready var transition_screen = get_node("transition")

func _ready():
	levels_manager.select_level(0)
	set_process_input(true)
	set_process(true)
	
func _input(event):
	if levels_manager.is_ready() && (event.type == InputEvent.KEY || event.type == InputEvent.SCREEN_TOUCH) && !event.pressed && level.get_child_count() == 0 && transition_screen.is_ready():
		transition_screen.play_split()
		load_level()
		
func _process(delta):
	if level.get_child_count() == 0 && levels_manager.is_ready():
		transition_screen.level_ready()

func show_menu():
	transition_screen.reset()

func change_level():
	transition_screen.reset()
	levels_manager.select_level(0)
	load_level()

func load_level():
	if levels_manager.is_ready():
		var instance = levels_manager.get_level_instance()
		instance.connect("menu", self, "_on_menu_requested")
		instance.connect("restart", self, "_on_restart_requested")
		instance.connect("next", self, "_on_next_requested")
		level.add_child(instance)
	
func _on_menu_requested():
	show_menu()
	
func _on_next_requested():
	levels_manager.select_next_level()
	transition_screen.reset()
	
func _on_transition_screen_closed():
	for child in level.get_children():
		child.queue_free()
	get_tree().set_pause(false)

func _on_transition_screen_opened():
	pass