extends HeroState

var water_prone = false
var death_prone = false


func on_enter():
	pass


func on_process(delta: float):

	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()


func on_physics_process(delta: float):
	hero.move_and_slide()


func on_exit():
	pass
