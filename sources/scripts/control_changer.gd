extends Area2D

var buttbutt = preload("res://sources/scripts/player/buttbutt.gd")

export(String, "move_up", "move_down", "move_left", "move_right", "run", "jump") var control_1 = "move_left"
export(String, "move_up", "move_down", "move_left", "move_right", "run", "jump") var control_2 = "move_right"

onready var label_c1 = get_node("control_1")
onready var label_c2 = get_node("control_2")

onready var sprite_c1 = get_node("control_1_sprite")
onready var sprite_c2 = get_node("control_2_sprite")
onready var particles = get_node("particles")

func _ready():
	label_c1.set_text(control_1)
	label_c2.set_text(control_2)
	update_sprites()
	connect("area_enter", self, "on_area_enter")

func on_area_enter(area):
	if area.get_parent() extends buttbutt:
		area.get_parent().change_controls(control_1, control_2)
		particles.set_emitting(true)

func update_sprites():
	update_sprite(control_1, sprite_c1)
	update_sprite(control_2, sprite_c2)
	
func update_sprite(control, sprite):
	sprite.play(control)