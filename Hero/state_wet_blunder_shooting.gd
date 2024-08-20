extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	timer_blunder_shoot_duration.set_wait_time(hero.BLUNDER_UNDERWATER_DURATION)
	hero.velocity.x = hero.BLUNDER_UNDERWATER_VELOCITY.x*hero.facing_direction
	hero.velocity.y = hero.BLUNDER_UNDERWATER_VELOCITY.y
	timer_blunder_shoot_duration.start()
	hero.blundershoot()

func on_process(_delta: float):
	if hero.is_on_wall()\
	and hero.facing_direction == round(hero.get_wall_normal().x):
		if hero.is_on_floor():
			machine.set_state("StateOnSeaFloor")
			return
		else:
			machine.set_state("StateFloating")
			return

	if timer_blunder_shoot_duration.is_stopped():
		if hero.is_on_floor():
			machine.set_state("StateOnSeaFloor")
			return
		else:
			machine.set_state("StateFloating")
			return


func on_physics_process(_delta: float):
	hero.move_and_slide()


func on_exit():
	timer_blunder_shoot_cooldown.start()
