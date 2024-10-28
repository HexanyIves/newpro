extends CollisionShape2D

## Must be inside a CheckpointGroup object in order to work.

enum Direction {
	LEFT = -1, ## Hero will respawn facing left.
	RIGHT = 1, ## Hero will respawn facing right.
	RECALL_HERO_DIRECTION = 0 ## Hero will respawn facing the direction he was when the trigger was entered.
	}
@export var direction: Direction = Direction.RECALL_HERO_DIRECTION
@export var always_trigger: bool = false ## If set to true, causes this checkpoint to work consecutively. When set to false (normal behavior), this checkpoint cannot be triggered multiple times in a row. NOTE: Developed so designers don't have to place two normal checkpoints back to back after boss battles.
