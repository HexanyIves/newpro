extends HeroState

var water_prone = true
var death_prone = true


func on_enter():
	if Input.is_action_pressed('jump')\
	and not get_node("../TimerBufferJump").is_stopped():
		get_node("../TimerBufferJump").stop()
		print("BUFFERED JUMP")
		machine.set_state("StateJumping")
		return

func on_process(delta: float):
	if hero.is_input_blunder_shoot()\
	and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.velocity.x != 0:
		machine.set_state("StateWalking")
		return
	if not hero.is_on_floor()\
	and hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return
	if Input.is_action_just_pressed('jump'):
		machine.set_state("StateJumping")
		return

	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
