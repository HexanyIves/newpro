extends HeroState

var water_prone = true
var death_prone = true

var can_wj: bool

func on_enter():
	hero.velocity.y = hero.CLIMB_VELOCITY
	can_wj = false

func on_process(delta: float):	
	print(can_wj)
	if Input.is_action_just_pressed('jump')\
	and hero.is_pushing_wall():
		hero.velocity.y = hero.CLIMB_VELOCITY
		can_wj = false
		return
	
	if Input.is_action_just_released('jump'): can_wj = true
	
	if hero.velocity.y < 0\
	and not hero.pelvis_rc.is_colliding()\
	and not hero.shoulder_rc.is_colliding()\
	and hero.next_grd_height.is_colliding()\
	and hero.is_pushing_wall(): # *ASSIST* Vault
		hero.velocity.y = hero.VAULT_VELOCITY
		hero.global_position.y = hero.next_grd_height.get_collision_point().y - %HeroCollider.shape.get_rect().size.y/2 - 1
		print("VAULT")
	
	if hero.is_input_blunder_shoot()\
	and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return
		
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
		
	if hero.is_move_dir_away_from_last_wall(false)\
	and not hero.is_on_wall()\
	and Input.is_action_just_pressed('jump'):
		timer_leaving_wall.stop()
		machine.set_state("StateWallJumping")
		print("mode 1")
		return
	
	if hero.is_move_dir_away_from_last_wall(false)\
	and can_wj\
	and Input.is_action_pressed('jump'):
		timer_leaving_wall.stop()
		machine.set_state("StateWallJumping")
		print("mode 2")
		return

	if hero.velocity.y > 0\
	and not hero.is_on_floor():
		machine.set_state("StateFalling")
		return
		
	if Input.is_action_just_released('jump'): hero.velocity.y *= 0.5
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

		
func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	hero.move_and_slide()


func on_exit():
	pass
