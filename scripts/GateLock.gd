class_name GateLock

extends Sprite2D

var _lock_speed = 100.0
var _max_movement = 32
var _end_position: Vector2

enum LockDirection {UP, DOWN, LEFT, RIGHT}

func set_end_position(direction: LockDirection):
	_end_position = position
	
	match direction:
		LockDirection.UP:
			_end_position.y -= _max_movement
			
		LockDirection.DOWN:
			_end_position.y += _max_movement
			
		LockDirection.LEFT:
			_end_position.x -= _max_movement
			
		LockDirection.RIGHT:
			_end_position.x += _max_movement

func move (delta: float, direction: LockDirection) -> bool:
	var move_amount = _lock_speed * delta
	var moved: float

	match direction:
		LockDirection.UP or LockDirection.DOWN:
			moved = move_toward(position.y, _end_position.y, move_amount)
			position.y += moved

		LockDirection.LEFT or LockDirection.RIGHT:
			moved = move_toward(position.x, _end_position.x, move_amount)
			position.x += moved

	return true if moved == 0.0 else false
