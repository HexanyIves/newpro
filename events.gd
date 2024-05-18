extends Node

signal hero_entered_water(water: Water, surface_global_pos: float)
signal hero_exited_water(water: Water)

signal hero_entered_camera_locker(camera_locker: CameraLocker, axes: Constants.Axes, lock_position: Vector2)
signal hero_exited_camera_locker(camera_locker: CameraLocker, axes: Constants.Axes)