extends Control

signal back
signal chosen_level

func _ready():
	for b in get_node("buttons").get_children():
		b.connect("pressed", self, "_on_button_pressed", [b])

func _on_button_pressed(target):
	emit_signal("chosen_level", target.level)

func _on_back_button_pressed():
	emit_signal("back")
