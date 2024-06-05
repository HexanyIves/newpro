extends HeroState

var water_prone: bool = true
var death_prone: bool = true


func on_enter():
	pass

func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
	and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shooter.shoot_ad_hoc(hero.regular_shot_speed)

	if hero.on_wall_value_just_changed\
	and not hero.is_on_wall():
		timer_leaving_wall.start()
		
	if not timer_leaving_wall.is_stopped()\
	and Input.is_action_pressed('jump')\
	and hero.is_move_dir_just_away_from_last_wall():
		timer_leaving_wall.stop()
		machine.set_state("StateWallJumping")
		print("MODE 4")
		return
	
	if not timer_leaving_wall.is_stopped()\
	and Input.is_action_just_pressed('jump')\
	and hero.is_move_dir_away_from_last_wall():
		timer_leaving_wall.stop()
		machine.set_state("StateWallJumping")
		print("MODE 5")
		return
	
	if not timer_climb_to_fall_wall_jump.is_stopped()\
	and Input.is_action_just_pressed('jump')\
	and hero.is_move_dir_away_from_last_wall():
		timer_climb_to_fall_wall_jump.stop()
		machine.set_state("StateWallJumping")
		print("MODE 6")
		return
	
	if Input.is_action_just_pressed('jump')\
	and not timer_blunder_jump_window.is_stopped():
		machine.set_state("StateBlunderJumping")
		return
	
	if Input.is_action_just_pressed('jump')\
	and hero.is_pushing_wall():
		machine.set_state("StateWallClimbing")
		return
	if Input.is_action_just_pressed('jump')\
	and not timer_coyote_jump.is_stopped():
		timer_coyote_jump.stop()
		machine.set_state("StateJumping")
		return

	if Input.is_action_just_pressed('jump'):
		timer_buffer_jump.start()

	if Input.is_action_pressed('jump'):
		machine.set_state("StateGliding")
		return

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return


func on_physics_process(delta: float):
	hero.step_grav(delta, hero.FAST_FALL_GRAVITY)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
