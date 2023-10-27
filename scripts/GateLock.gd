class_name GateLock

extends Sprite2D

enum LockDirections {UP, DOWN, LEFT, RIGHT}
enum LockColors {RED, GREEN, BLUE}

var _lock_speed = 4.0
var _max_movement = 24
var _end_position: Vector2

func set_move_direction(direction: LockDirections):
	_end_position = position

	match direction:
		LockDirections.UP:
			_end_position.y -= _max_movement
			
		LockDirections.DOWN:
			_end_position.y += _max_movement
			
		LockDirections.LEFT:
			_end_position.x -= _max_movement
			
		LockDirections.RIGHT:
			_end_position.x += _max_movement

func move_to_direction(delta: float) -> bool:
	var moved: float

	if _end_position.x != position.x:
		moved = (_end_position.x - position.x) * delta * _lock_speed
		position.x += moved 

	else:
		moved = (_end_position.y - position.y) * delta * _lock_speed
		position.y += moved

	if (moved > 0 and moved <= 0.1) or (moved < 0 and moved >= -0.1):
		position = _end_position
		moved = 0.0

	return true if moved == 0.0 else false
