extends Node2D

@export var print_stuff: bool = true
@export var input_stuff: bool = true

func _ready():
	pass

func _process(_delta):
	input_bin()
	print_bin()

func input_bin():
	if not input_stuff: return
	if Input.is_action_just_pressed("Debug Action 1"):
		pass #SaveManager.print_all_dics()
	if Input.is_action_just_pressed("Debug Action 2"):
		pass
		print(Utils.parse_time_as_string(AppManager.game_time, false))
	
	#if Input.is_action_just_pressed("shoot"): print("SHOOT!")
	#if Input.is_action_just_pressed("jump"): print("J")
	#if Input.is_action_just_pressed("move_left"): print("LEFT")
	#if Input.is_action_just_pressed("move_right"): print("RIGHT")
	#if Input.is_action_just_released("jump"): print("j")
	#if Input.is_action_just_released("move_left"): print("left")
	#if Input.is_action_just_released("move_right"): print("right")


func print_bin():
	if not print_stuff: return
