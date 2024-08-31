extends HeroState

var water_prone: bool = true
var death_prone: bool = true

var target_y_position: float

func on_enter():
	hero.velocity.y = hero.VAULT_VELOCITY
	target_y_position = hero.next_grd_height_rc.get_collision_point().y - %HeroCollider.shape.get_rect().size.y/2 - 1

func on_process(_delta: float):
	hero.step_shooting()

	if hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return
	
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return


func on_physics_process(delta: float):
	hero.global_position.y = lerp(hero.global_position.y, target_y_position, 15 * delta)
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	hero.move_and_slide()


func on_exit():
	pass
