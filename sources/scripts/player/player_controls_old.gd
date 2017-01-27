extends Node

onready var climb_area = preload("res://sources/scripts/levels/climb_area.gd")

onready var player = get_parent()
onready var player_sprites = player.get_node("sprites")
onready var interaction_area = player.get_node("interaction_area")

const WALK_SPEED = 150
const JUMP_SPEED = 400
const RUN_SPEED = 500

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var velocity = player.get_linear_velocity()
	var direction = Vector2(0,0)
	var can_climb = false
	
	var overlapping_areas = interaction_area.get_overlapping_areas()
	
	
	for area in overlapping_areas:
		if can_climb:
			break
		can_climb = area extends climb_area

	if can_climb && Input.is_action_pressed("move_up"):
		player.translate(Vector2(0,-5))
		velocity.y = 0
		
	if player.test_motion(Vector2(0,1)):
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("jump"):
			direction.y -= 1
		if Input.is_action_pressed("run"):
			velocity.x = direction.x * RUN_SPEED
		else:
			velocity.x = direction.x * WALK_SPEED
		velocity.y = direction.y * JUMP_SPEED
		
	player.set_linear_velocity(velocity)
	
	if velocity.y != 0:
		player_sprites.play("jump")
	elif velocity.x > 10:
		player_sprites.set_flip_h(false)
		player_sprites.play("walk")
	elif velocity.x < -10:
		player_sprites.set_flip_h(true)
		player_sprites.play("walk")
	else:
		player_sprites.play("stand")
