extends Node

signal menu
signal restart

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_menu_requested():
	emit_signal("menu")

func _on_pause_requested():
	get_node("tilemaps/objects/player").release_controls()

func _on_restart_requested():
	emit_signal("restart")