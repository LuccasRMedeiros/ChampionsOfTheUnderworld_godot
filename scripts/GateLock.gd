class_name GateLock

extends Sprite2D

var _lock_speed: float = 100.0
var _max_movement: int = 32
var _start_point: Vector2

enum LockDirection {UP, DOWN, LEFT, RIGHT}

func move (delta, direction: LockDirection) -> bool:
	var move_amount = (_lock_speed * delta) * 100 / _max_movement
	move_amount = _max_movement if move_amount > _max_movement else move_amount

	match direction:
		LockDirection.UP:
			if _start_point.y - position.y < _max_movement: 
				position.y -= move_amount
			else:
				return true

		LockDirection.DOWN:
			if position.y - _start_point.y < _max_movement:
				position.y += move_amount
			else:
				return true

		LockDirection.LEFT:
			if _start_point.x - position.x < _max_movement:
				position.x -= move_amount
			else:
				return true

		LockDirection.RIGHT:
			if position.x - _start_point.x < _max_movement:
				position.x += move_amount
			else:
				return true

	return false
