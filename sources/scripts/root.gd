extends Node

onready var level = get_node("level")
onready var transition_screen = get_node("transition")

func _ready():
	levels_manager.select_level(0)
	print(levels_manager.levels)
	set_process_input(true)
	set_process(true)
	
func _input(event):
	if levels_manager.is_ready() && (event.type == InputEvent.KEY || event.type == InputEvent.SCREEN_TOUCH) && !event.pressed && level.get_child_count() == 0 && transition_screen.is_ready():
		transition_screen.play_split()
		load_level()
		
func _process(delta):
	print(levels_manager.level_index, " ", levels_manager.is_ready())
	if level.get_child_count() == 0 && levels_manager.is_ready():
		transition_screen.level_ready()

func show_menu():
	get_tree().set_pause(false)
	transition_screen.reset()
	for child in level.get_children():
		child.queue_free()

func change_level():
	get_tree().set_pause(false)
	levels_manager.select_level(0)
	for child in level.get_children():
		child.queue_free()
	load_level()

func load_level():
	if levels_manager.is_ready():
		var instance = levels_manager.get_level_instance()
		print(instance)
		instance.connect("menu", self, "_on_menu_requested")
		instance.connect("restart", self, "_on_restart_requested")
		instance.connect("next", self, "_on_next_requested")
		level.add_child(instance)
	
func _on_menu_requested():
	show_menu()
	
func _on_next_requested():
	#levels_manager.select_next_level()
	change_level()