extends Control

signal level_selection_chosen
signal options_chosen
signal quit_chosen

func _ready():
	pass
	
func _on_level_selection_button_pressed():
	emit_signal("level_selection_chosen")


func _on_options_button_pressed():
	emit_signal("options_chosen")


func _on_quit_button_pressed():
	emit_signal("quit_chosen")
