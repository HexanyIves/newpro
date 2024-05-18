extends HeroState

var water_prone = false
var death_prone = true


func on_enter():
	pass

func on_process(delta: float):
	if not hero.is_on_water:
		machine.set_state("StateIdle")
		return
	if hero.can_dive:
		machine.set_state("StateDescending")
		return
	if hero.is_input_blunder_shoot()\
	and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateWetBlunderShooting")
		return
	if Input.is_action_just_pressed('jump')\
	and hero.is_on_floor():
		machine.set_state("StateJumping")
	if Input.is_action_just_pressed('jump')\
	and hero.is_pushing_wall()\
	and hero.is_head_above_water():
		machine.set_state("StateJumping")
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

func on_physics_process(delta: float):
	

	hero.velocity.y = (hero.velocity.y - (hero.BUOYANCY * (hero.global_position.y - (hero.last_water_surface))*delta))*pow(0.94, 1-delta)

	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass