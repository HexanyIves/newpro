class_name Door extends AnimatableBody2D

@export var duration: float = 1.0
@export var open_offset: Vector2 = Vector2(0.0, -288.0)
@export var auto_close_time: float = 0.0 ## If not zero, causes the door to automatically close after the specified time.
@onready var closed_pos: Vector2 = position
var state_machine: StateMachine
var door_tween: Tween
var door_collider: CollisionShape2D = null
signal should_open()
signal should_close()
signal stopped_moving_at_origin()
signal stopped_moving_at_offset()

func _ready():
	state_machine = $StateMachine
	if auto_close_time > 0:
		$StateMachine/TimerAutoClose.set_wait_time(auto_close_time)
	state_machine.start()
	
	if _find_door_collider():
		_setup_anticrush_area()
	
	$DoorStop.set_as_top_level(true)
	$DoorStop.global_position = self.global_position
	$DoorStop.material = self.material

func open():
	should_open.emit()

func close():
	should_close.emit()

func insta_open():
	if door_tween and door_tween.is_running():
		door_tween.kill()
	position = closed_pos + open_offset
	state_machine.set_state("DoorStateOpen")

func insta_close():
	if door_tween and door_tween.is_running():
		door_tween.kill()
	position = closed_pos
	state_machine.set_state("DoorStateClosed")

func tween_door_to_origin():
	tween_door(Vector2.ZERO)

func tween_door_to_offset():
	tween_door(open_offset)

func tween_door(offset: Vector2):
	door_tween = create_tween()
	door_tween.tween_property(
		self,
		"position",
		closed_pos + offset,
		duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	door_tween.finished.connect(_on_door_tween_finished)

func _on_door_tween_finished():
	if Utils.aprox_equal_vector2(position, closed_pos):
		stopped_moving_at_origin.emit()
	if Utils.aprox_equal_vector2(position, closed_pos + open_offset):
		stopped_moving_at_offset.emit()

func area_has_uncrushables() -> bool:
	var has: bool = false
	for body in $AntiCrushArea.get_overlapping_bodies():
		if body.is_in_group("uncrushables"):
			has = true
			break
	return has


func _setup_anticrush_area():
	var anti_crush_collider: CollisionShape2D = door_collider.duplicate()
	$AntiCrushArea.add_child(anti_crush_collider)
	$AntiCrushArea.set_as_top_level(true)
	$AntiCrushArea.global_position = global_position

func _find_door_collider() -> CollisionShape2D:
	var collider: CollisionShape2D = null
	for child in get_children():
		if child is CollisionShape2D:
			collider = child
			break
	door_collider = collider
	return collider
