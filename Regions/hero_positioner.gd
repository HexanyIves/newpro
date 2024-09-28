extends Marker2D
 
func _ready() -> void:
	if AppManager.developer_mode:
		AppManager.hero_ready.connect(_position_hero)

func _position_hero() -> void:
	print("Hero repositioned from ", AppManager.hero.global_position, " to ", self.global_position)
	AppManager.hero.global_position = self.global_position
	AppManager.hero.original_position = self.global_position