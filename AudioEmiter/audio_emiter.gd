class_name AudioEmiter extends Node2D

@export var sfx_name: StringName = "" ## The sound effect to be played, as named in AudioManager.SFX{}. Remember that looping is set directly on the import of the audio resource.
@export var max_distance: float = 1000.0 ## The distance after which the audio is inaudible.
@export var fixed_position: bool = true ## If true, once instantiated, the audio position will be fixed relative to the game level. Set it to false if the audio emiter is moving around, and leave as true if the emiter is static.
@export_group("Optionals")
@export var activation_area: Area2D = null ## If present and valid, the audio emiter will only activate after this Area2D is overlapped by the hero. Leave empty if the sound should be active from the start.
@export var deactivate_upon_leaving_activation_area: bool = false ## If an Area2D activation area was supplied, setting this variable to true will cause leaving the area to deactivate the audio emiter.
var currently_active: bool = false

func _ready():
	if activation_area:
		activation_area.body_entered.connect(func(body):
			if body is Hero:
				_activate()
			)
		if deactivate_upon_leaving_activation_area:
			activation_area.body_exited.connect(func(body):
				if body is Hero:
					_deactivate()
				)

func _process(_delta: float) -> void:
	AudioManager.update_positional_sfx_position(self, self.global_position)

func _enter_tree():
	if not activation_area:
		_activate()

func _exit_tree():
	_deactivate()

func _activate():
	currently_active = true
	AudioManager.play_positional_sfx(sfx_name, global_position, self, max_distance)

func _deactivate():
	currently_active = false
	AudioManager.stop_specific_positional_sfx(self)
