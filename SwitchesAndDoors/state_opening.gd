extends DoorState


func on_enter():
	door.tween_door_to_offset()
	door.stopped_moving_at_offset.connect(on_stopped_moving)
	door.close_d.connect(on_close_door)


func on_exit():
	door.stopped_moving_at_offset.disconnect(on_stopped_moving)
	if door.close_d.is_connected(on_close_door): # TODO: prevent code from attempting to disconnect this twice
		door.close_d.disconnect(on_close_door)


func on_stopped_moving():
	machine.set_state("StateOpen")


func on_close_door():
	machine.set_state("StateClosing")
