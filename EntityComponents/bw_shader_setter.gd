extends Node2D

@export var dark_color: Color = Color.BLACK ## The color that will replace the black pixels. Note: Only works as a fallback if the dark_color_name field is empty or invalid.
@export var dark_color_name: StringName ## The name of the constant bearing the desired color value, as implemented in the Constants file. This has priority over the color picker value.
@export var light_color: Color = Color.WHITE ## The color that will replace the white pixels. Note: Only works as a fallback if the light_color_name field is empty or invalid.
@export var light_color_name: StringName ## The name of the constant bearing the desired color value, as implemented in the Constants file. This has priority over the color picker value.
@onready var parent: Node2D = get_parent()
var mat: ShaderMaterial

func _ready() -> void:
	mat = ShaderMaterial.new()
	mat.shader = load("res://CaioShaders/bw_replacer.gdshader")
	parent.material = mat
	_update_color()

func _update_color() -> void:
	if not mat: return
	if Constants.get(dark_color_name):
		dark_color = Constants.get(dark_color_name)
	if Constants.get(light_color_name):
		light_color = Constants.get(light_color_name)
	mat.set_shader_parameter("replace_black", dark_color)
	mat.set_shader_parameter("replace_white", light_color)

func set_color_name(dark: StringName, light: StringName):
	dark_color_name = dark
	light_color_name = light
	_update_color()

func set_color(dark: Color, light: Color):
	dark_color_name = &""
	light_color_name = &""
	dark_color = dark
	light_color = light
	_update_color()
