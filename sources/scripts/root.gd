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
	if loaded_level != null && event.type == InputEvent.KEY && level.get_child_count() == 0 && transition_screen.is_ready():
		transition_screen.play_split()
		load_level()
	elif level.get_child_count() != 0 && event.is_action_pressed("restart"):
		restart()
		
func _process(delta):
	if loaded_level == null && queue.is_ready(first_level):
		loaded_level = queue.get_resource(first_level)
	if level.get_child_count() == 0 && loaded_level != null :
		transition_screen.level_ready()

func restart():
	for child in level.get_children():
		child.queue_free()
		transition_screen.reset()
		queue.queue_resource(first_level)

func load_level():
	if loaded_level != null:
		level.add_child(loaded_level.instance())
	
