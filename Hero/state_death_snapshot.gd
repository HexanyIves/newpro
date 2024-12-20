extends HeroState

var water_prone: bool = false
var death_prone: bool = false

func on_enter():
	hero.velocity = Vector2.ZERO
	AppManager.camera.shake()
	Events.hero_died.emit()
	timer_death_snapshot.start()
	Utils.colorize_silhouette(true, $"../../Gfx")
	$"../../Gfx/AnimatedSprite2D".stop()

func on_process(_delta: float):
	if timer_death_snapshot.is_stopped():
		Utils.colorize_silhouette(false, $"../../Gfx")
		machine.set_state("StateTweeningToRespawn")
