extends Node

onready var climb_area = preload("res://sources/scripts/levels/climb_area.gd")

onready var player_sprites = get_node("sprites")
onready var interaction_area = get_node("interaction_area")

const WALK_SPEED = 200
const JUMP_SPEED = 400
const RUN_SPEED = 500
const CLIMB_SPEED = 100
const GROUND_FRICTION_MULTIPLIER = 0.7
const GROUND_ACCELERATION_MULTIPLIER = 0.2
const AIR_FRICTION_MULTIPLIER = 0.95
const AIR_DIRECTION_MULTIPLIER = 0.15

var jumping = false

const IDLE = 0
const WALKING = 1
const RUNNING = 2
const JUMPING = 3
const FALLING = 4
const CLIMBING = 5
var fsm = IDLE

func _ready():
	set_process(true)
	
func _integrate_forces(state):
	if fsm == IDLE:
		integrate_idle(state)
	elif fsm == WALKING:
		integrate_walking(state)
	elif fsm == RUNNING:
		integrate_running(state)
	elif fsm == JUMPING:
		integrate_jumping(state)
	elif fsm == FALLING:
		integrate_falling(state)
	elif fsm == CLIMBING:
		integrate_climbing(state)
		
func integrate_idle(state):
	player_sprites.play("stand")
	var velocity = state.get_linear_velocity()
	velocity.x *= GROUND_FRICTION_MULTIPLIER
	state.set_linear_velocity(velocity)

func integrate_walking(state):
	player_sprites.play("walk")
	var velocity = state.get_linear_velocity()
	
	if abs(velocity.x) > WALK_SPEED:
		if Input.is_action_pressed("move_left"):
			player_sprites.set_flip_h(true)
		elif Input.is_action_pressed("move_right"):
			player_sprites.set_flip_h(false)
		velocity.x = clamp(velocity.x * (1 - GROUND_ACCELERATION_MULTIPLIER), -RUN_SPEED, RUN_SPEED)
	else:
		if Input.is_action_pressed("move_left"):
			velocity.x -= WALK_SPEED * GROUND_ACCELERATION_MULTIPLIER
			player_sprites.set_flip_h(true)
		elif Input.is_action_pressed("move_right"):
			velocity.x += WALK_SPEED * GROUND_ACCELERATION_MULTIPLIER
			player_sprites.set_flip_h(false)

		velocity.x = clamp(velocity.x, -WALK_SPEED, WALK_SPEED)

	state.set_linear_velocity(velocity)
		
func integrate_running(state):
	player_sprites.play("walk")
	var velocity = state.get_linear_velocity()
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= RUN_SPEED * GROUND_ACCELERATION_MULTIPLIER
		player_sprites.set_flip_h(true)
	elif Input.is_action_pressed("move_right"):
		velocity.x += RUN_SPEED * GROUND_ACCELERATION_MULTIPLIER
		player_sprites.set_flip_h(false)
		
	velocity.x = clamp(velocity.x, -RUN_SPEED, RUN_SPEED)
	
	state.set_linear_velocity(velocity)
		
func integrate_falling(state):
	player_sprites.play("jump")
	var velocity = state.get_linear_velocity()
	
	if velocity.x > -WALK_SPEED && Input.is_action_pressed("move_left"):
		player_sprites.set_flip_h(true)
		velocity.x -= WALK_SPEED * AIR_DIRECTION_MULTIPLIER
	elif velocity.x < WALK_SPEED && Input.is_action_pressed("move_right"):
		player_sprites.set_flip_h(false)
		velocity.x += WALK_SPEED * AIR_DIRECTION_MULTIPLIER
	elif !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
		velocity.x *= AIR_FRICTION_MULTIPLIER
		
	velocity.x = clamp(velocity.x, -RUN_SPEED, RUN_SPEED)
	state.set_linear_velocity(velocity)
	
func integrate_jumping(state):
	player_sprites.play("jump")
	state.set_linear_velocity(Vector2(state.get_linear_velocity().x,-JUMP_SPEED))

func integrate_climbing(state):
	player_sprites.play("jump")
	var velocity = state.get_linear_velocity()
	
	if Input.is_action_pressed("move_up"):
		velocity.y = -CLIMB_SPEED
	elif Input.is_action_pressed("move_down"):
		velocity.y = CLIMB_SPEED
	else:
		velocity.y = 0
	
	if Input.is_action_pressed("move_left"):
		velocity.x = - WALK_SPEED * GROUND_ACCELERATION_MULTIPLIER
		player_sprites.set_flip_h(true)
	elif Input.is_action_pressed("move_right"):
		velocity.x = WALK_SPEED * GROUND_ACCELERATION_MULTIPLIER
		player_sprites.set_flip_h(false)
	else:
		velocity.x = 0
	
	state.set_linear_velocity(velocity)

func _process(delta):
	var can_climb = false
	
	var overlapping_areas = interaction_area.get_overlapping_areas()
	
	for area in overlapping_areas:
		if can_climb:
			break
		can_climb = area extends climb_area

	if fsm == IDLE:
		if Input.is_action_pressed("jump"):
			fsm = JUMPING
			print("idle -> jump")
		elif Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
			fsm = WALKING
			print("idle -> walk")
		elif can_climb && ((Input.is_action_pressed("move_up") && !test_motion(Vector2(0,-5))) || (Input.is_action_pressed("move_down") && !test_motion(Vector2(0,5)))):
			#check if can climb and if thera are obstacles where we want to climb
			fsm = CLIMBING
			print("idle -> climb")
		elif !test_motion(Vector2(0,5)):
			fsm = FALLING
			print("idle -> fall")
			
	elif fsm == WALKING:
		if !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
			fsm = IDLE
			print("walk -> idle")
		elif Input.is_action_pressed("run"):
			fsm = RUNNING
			print("walk -> run")
		elif Input.is_action_pressed("jump"):
			fsm = JUMPING
			print("walk -> jump")
		elif can_climb && ((Input.is_action_pressed("move_up") && !test_motion(Vector2(0,-5))) || (Input.is_action_pressed("move_down") && !test_motion(Vector2(0,5)))):
			fsm = CLIMBING
			print("walk -> climb")
		elif !test_motion(Vector2(0,5)):
			fsm = FALLING
			print("walk -> fall")
			
	elif fsm == RUNNING:
		if !Input.is_action_pressed("run"):
			fsm = WALKING
			print("run -> walk")
		elif !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right"):
			fsm = IDLE
			print("run -> idle")
		elif Input.is_action_pressed("jump"):
			fsm = JUMPING
			print("run -> jump")
		elif can_climb && ((Input.is_action_pressed("move_up") && !test_motion(Vector2(0,-5))) || (Input.is_action_pressed("move_down") && !test_motion(Vector2(0,5)))):
			#check if can climb and if thera are obstacles where we want to climb
			fsm = CLIMBING
			print("run -> climb")
		elif !test_motion(Vector2(0,5)):
			fsm = FALLING
			print("run -> fall")
			
	elif fsm == CLIMBING:
		if !can_climb:
			fsm = FALLING
			print("climb -> fall")
		elif Input.is_action_pressed("jump"):
			fsm = JUMPING
			print("climb -> jump")
		elif test_motion(Vector2(0,5)):
			fsm = IDLE
			print("climb -> idle")
			
	elif fsm == FALLING:
		if can_climb && ((Input.is_action_pressed("move_up") && !test_motion(Vector2(0,-5))) || (Input.is_action_pressed("move_down") && !test_motion(Vector2(0,5)))):
			#check if can climb and if thera are obstacles where we want to climb
			fsm = CLIMBING
			print("fall -> climb")
		elif test_motion(Vector2(0,5)):
			fsm = IDLE
			print("fall -> idle")
			
	elif fsm == JUMPING:
		if !Input.is_action_pressed("jump"):
			fsm = FALLING
			print("jump -> fall")
