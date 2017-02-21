extends Node

signal menu
signal restart

onready var buttbutt = find_node("buttbutt")
onready var camera = buttbutt.get_node("Camera2D")
onready var menu_screen = find_node("menu_screen")

func _ready():
	pass

func reset():
	buttbutt.reset()
	camera.align()

func _on_buttbutt_die():
	reset()

func _on_buttbutt_exit():
	emit_signal("menu")

func _on_menu_screen_pause():
	if buttbutt != null:
		buttbutt.release_controls()

func _on_menu_screen_menu():
	emit_signal("menu")

func _on_menu_screen_restart():
	reset()
	menu_screen._on_resume_button_pressed()