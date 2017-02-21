
extends Area2D

onready var top = get_node("top")

func _ready():
	pass

func is_on_top(area):
	return area.overlaps_area(top)