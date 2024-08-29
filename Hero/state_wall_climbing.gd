extends HeroState

var water_prone: bool = true
var death_prone: bool = true

var can_wj: bool

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("wallclimb")

	hero.velocity.y = hero.CLIMB_VELOCITY
	can_wj = false

func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
	and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shoot()

	if Input.is_action_just_pressed('jump'):
		if hero.is_pushing_wall():
			$"../../Gfx/AnimatedSprite2D".frame = 0
			$"../../Gfx/AnimatedSprite2D".play("wallclimb")
			hero.velocity.y = hero.CLIMB_VELOCITY
			can_wj = false
			return

	if Input.is_action_just_released('jump'): can_wj = true
	
	if hero.velocity.y < 0\
	and not hero.pelvis_rc.is_colliding()\
	and not hero.shoulder_rc.is_colliding()\
	and hero.next_grd_height_rc.is_colliding()\
	and hero.is_pushing_wall():
		machine.set_state("StateVaulting")
		return

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
		
	if Input.is_action_just_released('jump'):
		hero.velocity.y *= 0.5

	if not hero.is_on_wall():
		$"../../Gfx/AnimatedSprite2D".play("vault")

func on_physics_process(delta: float):
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	hero.move_and_slide()
