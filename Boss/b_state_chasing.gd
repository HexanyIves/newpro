extends BossState


func on_enter():
	$"../../Flier".process_mode = Node.PROCESS_MODE_INHERIT
	t.wait_time = 4
	t.start()

func on_process(_delta: float):
	if t.is_stopped():
		machine.set_state("BStatePreDash")


func on_physics_process(_delta: float):
	pass


func on_exit():
	$"../../Flier".inertia_only = true
