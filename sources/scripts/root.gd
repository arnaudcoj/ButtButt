extends Node

onready var level = get_node("level")
onready var transition_screen = get_node("transition")

var queue = preload("res://sources/scripts/resource_queue.gd").new()
var loaded_level = null
export var first_level = "res://sources/scenes/levels/tiled_level.tscn"

func _ready():
	queue.start()
	if !queue.is_ready(first_level):
		queue.queue_resource(first_level)
	set_process_input(true)
	set_process(true)
	
func _input(event):
	if loaded_level != null && (event.type == InputEvent.KEY || event.type == InputEvent.SCREEN_TOUCH) && !event.pressed && level.get_child_count() == 0 && transition_screen.is_ready():
		transition_screen.play_split()
		load_level()
		
func _process(delta):
	if loaded_level == null && queue.is_ready(first_level):
		loaded_level = queue.get_resource(first_level)
	if level.get_child_count() == 0 && loaded_level != null :
		transition_screen.level_ready()

func show_menu():
	get_tree().set_pause(false)
	transition_screen.reset()
	for child in level.get_children():
		child.queue_free()
		queue.queue_resource(first_level)

func restart():
	get_tree().set_pause(false)
	queue.queue_resource(first_level)
	for child in level.get_children():
		child.queue_free()
	load_level()

func load_level():
	if loaded_level != null:
		var instance = loaded_level.instance()
		instance.connect("menu", self, "_on_menu_requested")
		instance.connect("restart", self, "_on_restart_requested")
		instance.connect("next", self, "_on_next_requested")
		level.add_child(instance)
	
func _on_menu_requested():
	show_menu()
	
func _on_restart_requested():
	restart()
	
func _on_next_requested():
	restart()