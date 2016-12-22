
extends Node

onready var player = get_parent()

func _ready():
	pass

func die():
	get_tree().reload_current_scene()
	#player.queue_free()
