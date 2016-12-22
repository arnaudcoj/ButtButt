
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	connect("area_enter", self, "on_area_enter")
	pass

func on_area_enter(area):
	if area.get_parent().has_node("behaviour"):
		var behaviour = area.get_parent().get_node("behaviour")
		if behaviour.has_method("die"):
			behaviour.die()
