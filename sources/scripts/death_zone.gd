extends Area2D

const buttbutt = preload("res://sources/scripts/player/buttbutt.gd")

func _ready():
	connect("area_enter", self, "on_area_enter")

func on_area_enter(area):
	if area.get_parent() extends buttbutt:
		area.get_parent().die()
	
	print("TODO death to reimplement with signals")
	pass
	if area.get_parent().has_node("behaviour"):
		var behaviour = area.get_parent().get_node("behaviour")
		if behaviour.has_method("die"):
			behaviour.die()
