extends Node

@export var use_parent_area: bool = false
var current_water_areas = []
var is_in_water: bool = false

signal water_state_changed(is_in_water: bool, water_area: Water)

func _ready() -> void:
	var area_node = get_parent() if use_parent_area else self
	
	area_node.area_entered.connect(func(area):
		if area is Water:
			if area not in current_water_areas:
				current_water_areas.append(area)
				if not is_in_water:
					is_in_water = true
					water_state_changed.emit(true, area)
	)
	
	area_node.area_exited.connect(func(area):
		if area is Water:
			if area in current_water_areas:
				current_water_areas.erase(area)
				if current_water_areas.is_empty():
					is_in_water = false
					water_state_changed.emit(false, area)
	)
