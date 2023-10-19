class_name GateLock

extends Sprite2D

var _lock_speed = 100.0
var _max_movement = 32
var _end_position: Vector2

enum LockDirections {UP, DOWN, LEFT, RIGHT}

func set_end_position(direction: LockDirections):
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

func move (delta: float, orientation: Definitions.CursorOrientations) -> bool:
	var move_amount = _lock_speed * delta
	var moved: float

	match orientation:
		Definitions.CursorOrientations.HORIZONTAL:
			moved = move_toward(position.y, _end_position.y, move_amount)
			position.y += moved

		Definitions.CursorOrientations.VERTICAL:
			moved = move_toward(position.x, _end_position.x, move_amount)
			position.x += moved

	return true if moved == 0.0 else false
