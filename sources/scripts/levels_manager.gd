extends Node

var levels = []
var level_index = -1

var queue = preload("res://sources/scripts/resource_queue.gd").new()
var loaded_level = null

func _ready():
	queue.connect("loading_complete", self, "_on_loading_complete")
	queue.start()
	populate_levels()
	
func populate_levels():
	levels.push_front("res://sources/scenes/levels/tiled_level.tscn")
	levels.push_front("res://sources/scenes/levels/tiled_level_1.tscn")

func select_level(idx):
	if idx == level_index:
		return true
	elif idx != -1 && idx < levels.size():
		level_index = idx
		loaded_level = null
		_load_level_in_background()
		return true
	return false

func select_next_level():
	return select_level(level_index +1)

func get_level_instance():
	if level_index != -1 && level_index < levels.size():
		if is_ready():
			var level = queue.get_resource(levels[level_index])
			if level != null:
				return level.instance()
	return null

func is_ready():
	return loaded_level != null
	
func _load_level_in_background():
	queue.queue_resource(levels[level_index])
		
func _on_loading_complete(path):
	loaded_level = queue.get_resource(path)