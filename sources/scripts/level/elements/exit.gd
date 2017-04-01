extends Area2D

var buttbutt = preload("res://scripts/entities/buttbutt.gd")

func _ready():
	connect("area_enter", self, "on_area_enter")

func on_area_enter(area):
	if area.get_parent() extends buttbutt:
		area.get_parent().exit()
