extends Node

signal controls_changed

var debug = false

const CONTROL_UP = "move_up"
const CONTROL_DOWN = "move_down"
const CONTROL_LEFT = "move_left"
const CONTROL_RIGHT = "move_right"
const CONTROL_RUN = "run"
const CONTROL_JUMP = "jump"

export var control_1 = CONTROL_RIGHT
export var control_2 = CONTROL_DOWN

onready var climb_area = preload("res://sources/scripts/levels/climb_area.gd")

onready var player_sprites = get_node("sprites")
onready var interaction_area = get_node("interaction_area")

const WALK_SPEED = 200
const JUMP_SPEED = 300
const RUN_SPEED = 500
const CLIMB_SPEED = 200
const GROUND_FRICTION_MULTIPLIER = 0.7
const GROUND_ACCELERATION_MULTIPLIER = 0.2
const AIR_FRICTION_MULTIPLIER = 0.95
const AIR_DIRECTION_MULTIPLIER = 0.15
const JUMP_TIME_MAX = 0.2
const FALLING_JUMP_DELAY = 0.2

var jumping = false
var jump_time = 0
var falling_time = 0

const IDLE = 0
const WALKING = 1
const RUNNING = 2
const JUMPING = 3
const FALLING = 4
const CLIMBING = 5
var fsm = IDLE

var touchscreen_left = -1
var touchscreen_right = -1

const JUMP_NOT_PRESSED = -1
const JUMP_PRESSED_LEFT = 0
const JUMP_PRESSED_RIGHT = 1
var jump_pressed = JUMP_NOT_PRESSED

func _ready():
	set_process(true)
	set_process_input(true)
	
func _input(event):
			
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			if event.pos.x > 1024 / 2 && touchscreen_right == -1:
				touchscreen_right = event.index
			elif touchscreen_left == -1:
				touchscreen_left = event.index
		else:
			if event.index == touchscreen_right:
				touchscreen_right = -1
			elif event.index == touchscreen_left:
				touchscreen_left = -1
		
		#if we release jump button we can jump again
		if touchscreen_left == -1 && jump_pressed == JUMP_PRESSED_LEFT:
			jump_pressed = JUMP_NOT_PRESSED
		elif touchscreen_right == -1 && jump_pressed == JUMP_PRESSED_RIGHT:
			jump_pressed = JUMP_NOT_PRESSED
	elif event.type == InputEvent.KEY:
		if event.is_action_released("jump"):
			jump_pressed = JUMP_NOT_PRESSED
	
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
		if is_action_pressed_and_available(CONTROL_LEFT):
			player_sprites.set_flip_h(true)
		elif is_action_pressed_and_available(CONTROL_RIGHT):
			player_sprites.set_flip_h(false)
		velocity.x = clamp(velocity.x * (1 - GROUND_ACCELERATION_MULTIPLIER), -RUN_SPEED, RUN_SPEED)
	else:
		if is_action_pressed_and_available(CONTROL_LEFT):
			velocity.x -= WALK_SPEED * GROUND_ACCELERATION_MULTIPLIER
			player_sprites.set_flip_h(true)
		elif is_action_pressed_and_available(CONTROL_RIGHT):
			velocity.x += WALK_SPEED * GROUND_ACCELERATION_MULTIPLIER
			player_sprites.set_flip_h(false)

		velocity.x = clamp(velocity.x, -WALK_SPEED, WALK_SPEED)

	state.set_linear_velocity(velocity)
		
func integrate_running(state):
	player_sprites.play("walk")
	var velocity = state.get_linear_velocity()
	
	if is_action_pressed_and_available(CONTROL_LEFT):
		velocity.x -= RUN_SPEED * GROUND_ACCELERATION_MULTIPLIER
		player_sprites.set_flip_h(true)
	elif is_action_pressed_and_available(CONTROL_RIGHT):
		velocity.x += RUN_SPEED * GROUND_ACCELERATION_MULTIPLIER
		player_sprites.set_flip_h(false)
		
	velocity.x = clamp(velocity.x, -RUN_SPEED, RUN_SPEED)
	
	state.set_linear_velocity(velocity)
		
func integrate_falling(state):
	player_sprites.play("jump")
	var velocity = state.get_linear_velocity()
	
	if velocity.x > -WALK_SPEED && is_action_pressed_and_available(CONTROL_LEFT):
		player_sprites.set_flip_h(true)
		velocity.x -= WALK_SPEED * AIR_DIRECTION_MULTIPLIER
	elif velocity.x < WALK_SPEED && is_action_pressed_and_available(CONTROL_RIGHT):
		player_sprites.set_flip_h(false)
		velocity.x += WALK_SPEED * AIR_DIRECTION_MULTIPLIER
	elif !is_action_pressed_and_available(CONTROL_LEFT) && !is_action_pressed_and_available(CONTROL_RIGHT):
		velocity.x *= AIR_FRICTION_MULTIPLIER
		
	velocity.x = clamp(velocity.x, -RUN_SPEED, RUN_SPEED)
	state.set_linear_velocity(velocity)
	
func integrate_jumping(state):
	player_sprites.play("jump")
	if jump_pressed == JUMP_NOT_PRESSED:
		if control_1 == "jump":
			jump_pressed = JUMP_PRESSED_LEFT
		elif control_2 == "jump":
			jump_pressed = JUMP_PRESSED_RIGHT
			
	var velocity = state.get_linear_velocity()
	
	if velocity.x > -WALK_SPEED && is_action_pressed_and_available(CONTROL_LEFT):
		player_sprites.set_flip_h(true)
		velocity.x -= WALK_SPEED * AIR_DIRECTION_MULTIPLIER
	elif velocity.x < WALK_SPEED && is_action_pressed_and_available(CONTROL_RIGHT):
		player_sprites.set_flip_h(false)
		velocity.x += WALK_SPEED * AIR_DIRECTION_MULTIPLIER
	elif !is_action_pressed_and_available(CONTROL_LEFT) && !is_action_pressed_and_available(CONTROL_RIGHT):
		velocity.x *= AIR_FRICTION_MULTIPLIER
		
	velocity.x = clamp(velocity.x, -RUN_SPEED, RUN_SPEED)
	
	velocity.y = -JUMP_SPEED
	state.set_linear_velocity(velocity)

func integrate_climbing(state):
	player_sprites.play("jump")
	var velocity = state.get_linear_velocity()
	
	if is_action_pressed_and_available(CONTROL_UP):
		velocity.y = -CLIMB_SPEED
	elif is_action_pressed_and_available(CONTROL_DOWN):
		velocity.y = CLIMB_SPEED
	
	if is_action_pressed_and_available(CONTROL_LEFT):
		velocity.x = - WALK_SPEED * 0.6
		player_sprites.set_flip_h(true)
	elif is_action_pressed_and_available(CONTROL_RIGHT):
		velocity.x = WALK_SPEED * 0.6
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
		if is_action_pressed_and_available(CONTROL_JUMP) && jump_pressed == JUMP_NOT_PRESSED:
			fsm = JUMPING
			if debug: print("idle -> jump")
		elif is_action_pressed_and_available(CONTROL_LEFT) || is_action_pressed_and_available(CONTROL_RIGHT):
			fsm = WALKING
			if debug: print("idle -> walk")
		elif can_climb && ((is_action_pressed_and_available(CONTROL_UP) && !test_motion(Vector2(0,-5))) || (is_action_pressed_and_available(CONTROL_DOWN) && !test_motion(Vector2(0,5)))):
			#check if can climb and if thera are obstacles where we want to climb
			fsm = CLIMBING
			if debug: print("idle -> climb")
		elif !test_motion(Vector2(0,5)):
			fsm = FALLING
			if debug: print("idle -> fall")
			
	elif fsm == WALKING:
		if !is_action_pressed_and_available(CONTROL_LEFT) && !is_action_pressed_and_available(CONTROL_RIGHT):
			fsm = IDLE
			if debug: print("walk -> idle")
		elif is_action_pressed_and_available(CONTROL_RUN):
			fsm = RUNNING
			if debug: print("walk -> run")
		elif is_action_pressed_and_available(CONTROL_JUMP):
			fsm = JUMPING
			if debug: print("walk -> jump")
		elif can_climb && ((is_action_pressed_and_available(CONTROL_UP) && jump_pressed == JUMP_NOT_PRESSED && !test_motion(Vector2(0,-5))) || (is_action_pressed_and_available(CONTROL_DOWN) && !test_motion(Vector2(0,5)))):
			fsm = CLIMBING
			if debug: print("walk -> climb")
		elif !test_motion(Vector2(0,5)):
			fsm = FALLING
			if debug: print("walk -> fall")
			
	elif fsm == RUNNING:
		if !is_action_pressed_and_available(CONTROL_RUN):
			fsm = WALKING
			if debug: print("run -> walk")
		elif !is_action_pressed_and_available(CONTROL_LEFT) && !is_action_pressed_and_available(CONTROL_RIGHT):
			fsm = IDLE
			if debug: print("run -> idle")
		elif is_action_pressed_and_available(CONTROL_JUMP) && jump_pressed == JUMP_NOT_PRESSED :
			fsm = JUMPING
			if debug: print("run -> jump")
		elif can_climb && ((is_action_pressed_and_available(CONTROL_UP) && !test_motion(Vector2(0,-5))) || (is_action_pressed_and_available(CONTROL_DOWN) && !test_motion(Vector2(0,5)))):
			#check if can climb and if thera are obstacles where we want to climb
			fsm = CLIMBING
			if debug: print("run -> climb")
		elif !test_motion(Vector2(0,5)):
			fsm = FALLING
			if debug: print("run -> fall")
			
	elif fsm == CLIMBING:
		if !can_climb:
			fsm = FALLING
			if debug: print("climb -> fall")
		elif is_action_pressed_and_available(CONTROL_JUMP) && jump_pressed == JUMP_NOT_PRESSED :
			fsm = JUMPING
			if debug: print("climb -> jump")
		elif !is_action_pressed_and_available(CONTROL_UP) && !is_action_pressed_and_available(CONTROL_DOWN) && test_motion(Vector2(0,5)):
			fsm = IDLE
			if debug: print("climb -> idle")
			
	elif fsm == FALLING:
		falling_time += delta
		if can_climb && ((is_action_pressed_and_available(CONTROL_UP) && !test_motion(Vector2(0,-5))) || (is_action_pressed_and_available(CONTROL_DOWN) && !test_motion(Vector2(0,5)))):
			#check if can climb and if thera are obstacles where we want to climb
			fsm = CLIMBING
			falling_time = 0
			if debug: print("fall -> climb")
		elif test_motion(Vector2(0,5)):
			fsm = IDLE
			falling_time = 0
			if debug: print("fall -> idle")
		elif is_action_pressed_and_available(CONTROL_JUMP) && jump_pressed == JUMP_NOT_PRESSED && falling_time < FALLING_JUMP_DELAY:
			fsm = JUMPING
			if debug: print("fall -> jump")
			
	elif fsm == JUMPING:
		jump_time += delta
		if !is_action_pressed_and_available(CONTROL_JUMP) || jump_time > JUMP_TIME_MAX:
			fsm = FALLING
			jump_time = 0
			falling_time = FALLING_JUMP_DELAY
			if debug: print("jump -> fall")
			
func is_action_pressed_and_available(action):
	return ((action == control_1 || action == control_2) && Input.is_action_pressed(action)) || (touchscreen_left != -1 && action == control_1) || (touchscreen_right != -1 && action == control_2)

func change_controls(control_1, control_2):
	self.control_1 = control_1
	self.control_2 = control_2
	emit_signal("controls_changed", self)