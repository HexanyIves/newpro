class_name Door extends AnimatableBody2D

@export var duration: float = 1.0
@export var open_offset: Vector2 = Vector2(0.0, -100.0)
@export var auto_close_time: float = 0.0 ## If different than zero, will cause the door to automatically close after the specified time.
@export var state_machine: StateMachine ## The state machine that governs doors. Drag-and-drop the state-machine object to this field.
@onready var closed_pos: Vector2 = position
var door_tween: Tween
signal open_d()
signal close_d()
signal stopped_moving_at_origin()
signal stopped_moving_at_offset()

func _ready():
	if auto_close_time > 0:
		$StateMachine/TimerAutoClose.set_wait_time(auto_close_time)
	state_machine.start()


func _process(_delta):
	area_has_uncrushables()
	if Input.is_action_just_pressed("Debug Action 1"): open_d.emit()
	if Input.is_action_just_pressed("Debug Action 2"): close_d.emit()


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
		duration).set_trans(Tween.TRANS_EXPO)
	door_tween.finished.connect(on_tween_finished)


func on_tween_finished():
	if Utils.aprox_equal_vector2(position, closed_pos):
		print("BROADCAST: is at origin")
		stopped_moving_at_origin.emit()
	if Utils.aprox_equal_vector2(position, closed_pos + open_offset):
		print("BROADCAST: is at offset")
		stopped_moving_at_offset.emit()


func area_has_uncrushables() -> bool:
	var has: bool = false
	for body in $AntiCrushArea.get_overlapping_bodies():
		if body.is_in_group("uncrushables"):
			has = true
			break
	return has
