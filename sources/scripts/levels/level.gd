extends Node

signal menu
signal restart

onready var buttbutt = find_node("buttbutt")
onready var menu_screen = find_node("menu_screen")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_menu_requested():
	emit_signal("menu")

func _on_pause_requested():
	buttbutt.release_controls()

func _on_restart_requested():
	emit_signal("restart")

func _on_buttbutt_die():
	emit_signal("restart")

func _on_buttbutt_exit():
	print("TODO next level when exit")
	emit_signal("menu")
