extends Control

onready var main_menu = get_node("main_menu")
onready var level_selection_screen = get_node("level_selection_screen")

func _ready():
	go_to_main_menu()

func _on_level_selection_chosen():
	go_to_level_selection()

func _on_level_selection_screen_back():
	go_to_main_menu()
	
func _on_level_selection_screen_chosen_level(level):
	print(level)


func go_to_main_menu():
	main_menu.show()
	level_selection_screen.hide()
	
func go_to_level_selection():
	main_menu.hide()
	level_selection_screen.show()
	