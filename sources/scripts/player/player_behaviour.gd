
extends Node

onready var player = get_parent()

func _ready():
	pass

func die():
	get_tree().get_root().get_node("root").restart()

func change_controls(control_1, control_2):
	player.control_1 = control_1
	player.control_2 = control_2
	player.emit_signal("controls_changed", player)
	
func exit():
	get_tree().get_root().get_node("root").restart()