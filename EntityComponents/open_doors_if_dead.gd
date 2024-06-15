class_name OpenDoorsIfDead extends Node2D

@export var doors_to_open: Array[Door] = []
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())


func _ready():
	if dmg_taker != null:
		dmg_taker.died.connect(func():
			for d in doors_to_open:
				d.open()
			)
		dmg_taker.resurrected.connect(func():
			for d in doors_to_open:
				d.insta_close()
			)
