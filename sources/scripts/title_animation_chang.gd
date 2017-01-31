extends Polygon2D

onready var animation = get_node("animation")
onready var timer = get_node("title/timer")

func _ready():
	pass

func _on_timer_timeout():
	animation.set_speed(random_speed())
	if randf() > 0.5:
		animation.play(random_animation())
	else:
		animation.play_backwards(random_animation())


func _on_animation_finished():
	if !animation.is_playing():
		timer.start()

func random_animation():
	var animation_list = animation.get_animation_list()
	var index = randi() % animation_list.size()
	return animation_list[index]

func random_speed():
	var speed = randf() + 0.5
	return speed

func stop():
	animation.stop_all()
	timer.stop()
	
func reset():
	timer.start()
