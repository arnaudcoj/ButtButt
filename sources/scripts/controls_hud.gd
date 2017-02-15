extends CanvasLayer

onready var sprite_c1 = get_node("control_1_sprite")
onready var sprite_c2 = get_node("control_2_sprite")
onready var particles_c1 = sprite_c1.get_node("particles")
onready var particles_c2 = sprite_c2.get_node("particles")

func _ready():
	pass

func _on_buttbutt_controls_changed(buttbutt):
	if sprite_c1.get_animation() != buttbutt.control_1:
		sprite_c1.play(buttbutt.control_1)
		particles_c1.set_emitting(true)
	if sprite_c2.get_animation() != buttbutt.control_2:
		sprite_c2.play(buttbutt.control_2)
		particles_c2.set_emitting(true)
