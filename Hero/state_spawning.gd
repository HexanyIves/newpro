extends HeroState

var water_prone: bool = false
var death_prone: bool = false

func on_enter():
	var destination = hero.original_position
	if not hero.current_checkpoint_path:
		hero.current_checkpoint_path = RegionManager.current_region.default_checkpoint_trigger.get_path()
	if hero.current_checkpoint_path:
		var curr_checkpoint = get_node(hero.current_checkpoint_path)
		if curr_checkpoint:
			destination = curr_checkpoint.spawn_pivot
			hero.facing_direction = hero.current_checkpoint_direction
	hero.global_position = destination

	Events.hero_first_spawned.emit()
	hero.force_water_detection()

	machine.set_state("StateIdle")

func on_exit():
	Utils.create_blinking_timer(hero, 0.08, 0.5)
