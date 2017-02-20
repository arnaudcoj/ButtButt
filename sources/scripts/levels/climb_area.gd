
extends Area2D

onready var top = get_node("top")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func is_on_top(area):
	return area.overlaps_area(top)
