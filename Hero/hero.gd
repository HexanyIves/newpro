extends CharacterBody2D

@export var SPEED = 300.0 ## The moving speed of the hero.
@export var JUMP_VELOCITY = -400.0 ## The speed the hero jumps when grounded.
@export var WALLJUMP_VELOCITY = Vector2(800, -400) ## The speed the hero walljumps away from a wall.
@export var CLIMB_VELOCITY = -400.0 ## The speed the hero jumps upward when jumping to the same side of the wall (Megaman-style walljump).
@export var GLIDE_VELOCITY = 50.0 ## The speed at which the hero slowly descends when airborne and holding Jump.
@export var BLUNDER_AIRBORNE_VELOCITY = Vector2(-800, 0) ## The strenth of the recoil when blunderjumping on air.
@export var BLUNDER_GROUNDED_VELOCITY = Vector2(-800, 0) ## The strenth of the recoil when blunderjumping on ground.
@export var BLUNDER_AIRBORNE_DURATION = 1 ## The duration of the recoil when blunderjumping on air.
@export var BLUNDER_GROUNDED_DURATION = 0.5 ## The duration of the recoil when blunderjumping on ground.
@export var BLUNDER_JUMP_VELOCITY = -400.0 ## The speed the hero jumps after blundershooting airborne.
@export var state_machine: StateMachine ## The state machine that governs this player controller. Drag-and-drop the state-machine object to this field.
@export var bullet_manager: Node
var facing_direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_safe_margin(0.08)
	state_machine.start()

func _process(delta):
	pass

func _physics_process(delta):
	pass

func step_grav(delta):
	if not is_on_floor(): velocity.y += gravity * delta
	
func step_lateral_mov(delta):
	if Input.is_action_pressed("move_left"):
		facing_direction = -1
		velocity.x = facing_direction * SPEED

	elif Input.is_action_pressed("move_right"):
		facing_direction = 1
		velocity.x = facing_direction * SPEED
		
	else: velocity.x = 0

func is_pushing_wall() -> bool:
	var pushing_wall = false
	var push_left = facing_direction == -1 and Input.is_action_pressed("move_left")
	var push_right = facing_direction == 1 and Input.is_action_pressed("move_right")
	if is_on_wall() and (push_left or push_right):
			pushing_wall = facing_direction == -round(get_wall_normal().x)
	return pushing_wall

func is_move_dir_away_from_last_wall(just: bool) -> bool:
	var mov_away
	if just:
		mov_away = (round(get_wall_normal().x) == -1 and Input.is_action_just_pressed('move_left'))\
		or (round(get_wall_normal().x) == 1 and Input.is_action_just_pressed('move_right'))
	else:
		mov_away = (round(get_wall_normal().x) == -1 and Input.is_action_pressed('move_left'))\
		or (round(get_wall_normal().x) == 1 and Input.is_action_pressed('move_right'))
	return mov_away

func is_input_blunder_shoot() -> bool:
	return Input.is_action_pressed('duck') and Input.is_action_just_pressed("shoot")
	
func shoot_regular():
	var bullet = bullet_manager.create_bullet(facing_direction, position)

func shoot_blunder(amount: int, interval_angle: float):
	var top_angle =  (amount-1) * interval_angle / 2
	for i in range(amount):
		bullet_manager.create_bullet(facing_direction, position, top_angle - interval_angle * i)
	
