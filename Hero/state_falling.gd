extends HeroState

var water_prone: bool = true
var death_prone: bool = true
var top_fall_vel: float


func on_enter():
	top_fall_vel = 0
	$"../../Gfx/AnimatedSprite2D".play("fall_in")
	if Input.is_action_just_pressed('jump'):
		timer_buffer_walljump.start()

func on_process(_delta: float):
	if hero.velocity.y > top_fall_vel:
		top_fall_vel = hero.velocity.y

	if Input.is_action_just_pressed('jump'):
		timer_buffer_walljump.start()

	if hero.is_input_blunder_shoot()\
	and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shoot()

	if hero.on_wall_value_just_changed\
	and not hero.is_on_wall():
		timer_leaving_wall.start()

	if Input.is_action_just_pressed('jump')\
	and not timer_blunder_jump_window.is_stopped():
		machine.set_state("StateBlunderJumping")
		return
	
	if Input.is_action_just_pressed('jump')\
	and hero.is_pushing_wall():
		machine.set_state("StateWallClimbing")
		return

	if hero.is_pushing_wall()\
	and not timer_buffer_climbing.is_stopped():
		timer_buffer_climbing.stop()
		machine.set_state("StateWallClimbing")
		if DebugTools.print_stuff: print("ASSISTED")
		return

	if Input.is_action_just_pressed('jump')\
	and not timer_coyote_jump.is_stopped():
		timer_coyote_jump.stop()
		machine.set_state("StateJumping")
		return

	if Input.is_action_just_pressed('jump'):
		timer_buffer_jump.start()
		timer_buffer_climbing.start()

	if Input.is_action_pressed('jump')\
	and hero.velocity.y > 1000:
		machine.set_state("StateGliding")
		return
	
	if Input.is_action_pressed('jump')\
	and hero.is_pushing_wall()\
	and hero.pelvis_rc.is_colliding()\
	and hero.shoulder_rc.is_colliding():
		machine.set_state("StateWallGrabbing")
		return

	if hero.is_on_floor():
		if top_fall_vel > 1200:
			PropManager.place_prop(hero.global_position, &"dust_pound")
		machine.set_state("StateIdle")
		return


func on_physics_process(delta: float):
	hero.step_grav(delta, hero.FAST_FALL_GRAVITY)
	hero.step_lateral_mov(delta)
	hero.step_walljump()
	hero.move_and_slide()


func on_exit():
	pass
