class_name GateLock

extends Node2D

var _lock_speed = 100.0
var _max_movement = 32

enum LockDirection {UP, DOWN, LEFT, RIGHT}

func move(delta, direction: LockDirection):
	var finished_movement: bool
	var move_amount = _lock_speed * delta

	match direction:
		LockDirection.UP:
			position.y -= move_amount

		LockDirection.DOWN:
			position.y += move_amount

		LockDirection.LEFT:
			position.x -= move_amount

		LockDirection.RIGHT:
			position.x += move_amount
