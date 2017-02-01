
extends Node

onready var player = get_parent()

func _ready():
	pass

func die():
	get_tree().get_root().get_node("root").restart()

func change_controls(control_1, control_2):
	if player != null:
		player.change_controls(control_1, control_2)
	
func exit():
	get_tree().get_root().get_node("root").restart()