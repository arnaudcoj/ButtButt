extends Node

signal menu
signal restart
signal next

onready var buttbutt = find_node("buttbutt")
onready var camera = buttbutt.get_node("Camera2D")
onready var menu_screen = find_node("menu_screen")
onready var game_over_screen = find_node("game_over_screen")
onready var success_screen = find_node("success_screen")

func _ready():
	reset()

func reset():
	buttbutt.reset()
	camera.align()
	
	menu_screen.set_enabled(true)
	menu_screen.close()
	
	game_over_screen.close()
	game_over_screen.set_enabled(false)
	
	success_screen.close()
	success_screen.set_enabled(false)

func _on_buttbutt_die():
	menu_screen.set_enabled(false)
	success_screen.set_enabled(false)
	game_over_screen.set_enabled(true)
	game_over_screen.open()

func _on_buttbutt_exit():
	menu_screen.set_enabled(false)
	game_over_screen.set_enabled(false)
	success_screen.set_enabled(true)
	success_screen.open()

func _on_menu_screen_pause():
	if buttbutt != null:
		buttbutt.release_controls()

func _on_menu_screen_menu():
	emit_signal("menu")

func _on_menu_screen_restart():
	reset()

func _on_menu_screen_next():
	emit_signal("next")
