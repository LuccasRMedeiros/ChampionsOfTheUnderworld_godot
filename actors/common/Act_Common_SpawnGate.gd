extends Node2D


enum GateStates {LOCKED, OPEN, CLOSE}


signal select
signal open_gate
signal close_gate


var _next_warp = 24
var _loop_warp = -48
var _gate_state = GateStates.LOCKED
var _cursor_rc = 1
var _gate_lock_red = preload("res://actors/common/Act_Common_RedLock.tscn")
var _gate_lock_green = preload("res://actors/common/Act_Common_GreenLock.tscn")
var _gate_lock_blue = preload("res://actors/common/Act_Common_BlueLock.tscn")
var _lock_node_matrix = [
	[GateLock, GateLock, GateLock],
	[GateLock, GateLock, GateLock],
	[GateLock, GateLock, GateLock]
	]
var _new_lock: GateLock


var cursor_orientation = Definitions.CursorOrientations.HORIZONTAL


@export var summon_direction: Spawner.DaemonDirections


func _change_cursor_orientation():
	var position_bckp = $Cursor.position
	
	$Cursor.position.x = position_bckp.y
	$Cursor.position.y = position_bckp.x

	if cursor_orientation == Definitions.CursorOrientations.HORIZONTAL:
		$Cursor.rotation_degrees = 90.0
		cursor_orientation = Definitions.CursorOrientations.VERTICAL
	else:
		$Cursor.rotation_degrees = 0
		cursor_orientation = Definitions.CursorOrientations.HORIZONTAL


# Called when the node enters the scene tree for the first time.
func _ready():
	$Spawner.direction = summon_direction

	shuffle_matrix()

	for row_i in _lock_node_matrix.size():
		for column_i in _lock_node_matrix[row_i].size():
			add_child(_lock_node_matrix[row_i][column_i])


func _process(delta):
	match _gate_state:
		GateStates.OPEN:
			if $Spawner.spawn(delta) == 3:
				$Cursor.visible = true
				$Spawner.reset_spawn_number()
				_gate_state = GateStates.CLOSE
				close_gate.emit()

		GateStates.CLOSE:
			shuffle_matrix()
			_gate_state = GateStates.LOCKED


func move_cursor(direction: Definitions.CursorDirections):
	var cursor_warp: Vector2
	var warp_amount = _next_warp

	if direction == Definitions.CursorDirections.FORWARD:
		_cursor_rc = _cursor_rc + 1 

		if _cursor_rc == 3:
			_cursor_rc = 0
			warp_amount = _loop_warp

		warp_amount *= -1

	elif direction == Definitions.CursorDirections.BACKWARD:
		_cursor_rc = _cursor_rc - 1

		if _cursor_rc == -1:
			_cursor_rc = 2
			warp_amount = _loop_warp

	if cursor_orientation == Definitions.CursorOrientations.HORIZONTAL:
		cursor_warp = Vector2(0.0, float(warp_amount))

	elif cursor_orientation == Definitions.CursorOrientations.VERTICAL:
		cursor_warp = Vector2(float(warp_amount), 0.0)

	$Cursor.position -= cursor_warp


func set_locks_direction(direction: GateLock.LockDirections):
	var lock_to_dup: GateLock
	var new_lock_position: Vector2

	$Cursor.visible = false
	_change_cursor_orientation()

	match direction:
		GateLock.LockDirections.LEFT:
			lock_to_dup = _lock_node_matrix[_cursor_rc][0]
			new_lock_position = \
				_lock_node_matrix[_cursor_rc][2].position + Vector2(24.0, 0.0)

		GateLock.LockDirections.RIGHT:
			lock_to_dup = _lock_node_matrix[_cursor_rc][2]
			new_lock_position = \
				_lock_node_matrix[_cursor_rc][0].position - Vector2(24.0, 0.0)

		GateLock.LockDirections.UP:
			lock_to_dup = _lock_node_matrix[0][_cursor_rc]
			new_lock_position = \
				_lock_node_matrix[2][_cursor_rc].position + Vector2(0.0, 24.0)

		GateLock.LockDirections.DOWN:
			lock_to_dup = _lock_node_matrix[2][_cursor_rc]
			new_lock_position = \
				_lock_node_matrix[0][_cursor_rc].position - Vector2(0.0, 24.0)

	if lock_to_dup is GateLock_Red:
		_new_lock = _gate_lock_red.instantiate()
	elif lock_to_dup is GateLock_Green:
		_new_lock = _gate_lock_green.instantiate()
	elif lock_to_dup is GateLock_Blue:
		_new_lock = _gate_lock_blue.instantiate()

	_new_lock.position = new_lock_position
	add_child(_new_lock)

	_new_lock.set_move_direction(direction)
	if direction == GateLock.LockDirections.LEFT \
	or direction == GateLock.LockDirections.RIGHT:
		for lock in _lock_node_matrix[_cursor_rc]:
			lock.set_move_direction(direction)

	else:
		for i in _lock_node_matrix.size():
			_lock_node_matrix[i][_cursor_rc].set_move_direction(direction)


func move_locks(delta: float, direction: GateLock.LockDirections):
	var are_locks_aligned: bool
	var locks_moved: bool

	_new_lock.move_to_direction(delta)
	if direction == GateLock.LockDirections.LEFT \
	or direction == GateLock.LockDirections.RIGHT:

		for lock in _lock_node_matrix[_cursor_rc]:
			locks_moved = lock.move_to_direction(delta)

	else:
		for i in _lock_node_matrix.size():
			locks_moved = _lock_node_matrix[i][_cursor_rc].move_to_direction(delta)

	if locks_moved == true:
		match direction:
			GateLock.LockDirections.LEFT:
				_lock_node_matrix[_cursor_rc][0].queue_free()

				_lock_node_matrix[_cursor_rc][0] = \
					_lock_node_matrix[_cursor_rc][1]
				_lock_node_matrix[_cursor_rc][1] = \
					_lock_node_matrix[_cursor_rc][2]
				_lock_node_matrix[_cursor_rc][2] = _new_lock

			GateLock.LockDirections.RIGHT:
				_lock_node_matrix[_cursor_rc][2].queue_free()

				_lock_node_matrix[_cursor_rc][2] = \
					_lock_node_matrix[_cursor_rc][1]
				_lock_node_matrix[_cursor_rc][1] = \
					_lock_node_matrix[_cursor_rc][0]
				_lock_node_matrix[_cursor_rc][0] = _new_lock

			GateLock.LockDirections.UP:
				_lock_node_matrix[0][_cursor_rc].queue_free()

				_lock_node_matrix[0][_cursor_rc] = \
					_lock_node_matrix[1][_cursor_rc]
				_lock_node_matrix[1][_cursor_rc] = \
					_lock_node_matrix[2][_cursor_rc]
				_lock_node_matrix[2][_cursor_rc] = _new_lock

			GateLock.LockDirections.DOWN:
				_lock_node_matrix[2][_cursor_rc].queue_free()

				_lock_node_matrix[2][_cursor_rc] = \
					_lock_node_matrix[1][_cursor_rc]
				_lock_node_matrix[1][_cursor_rc] = \
					_lock_node_matrix[0][_cursor_rc]
				_lock_node_matrix[0][_cursor_rc] = _new_lock

		for row in _lock_node_matrix.size():
			are_locks_aligned = true

			if \
				_lock_node_matrix[row][0].lock_color != \
				_lock_node_matrix[row][1].lock_color \
			or \
				_lock_node_matrix[row][1].lock_color != \
				_lock_node_matrix[row][2].lock_color:
				are_locks_aligned = false

				break

		if are_locks_aligned == false:
			for column in _lock_node_matrix.size():
				are_locks_aligned = true

				if \
					_lock_node_matrix[0][column].lock_color != \
					_lock_node_matrix[1][column].lock_color \
				or \
					_lock_node_matrix[1][column].lock_color != \
					_lock_node_matrix[2][column].lock_color:
					are_locks_aligned = false

					break

	if are_locks_aligned == true:
		open_gate.emit()
		_gate_state = GateStates.OPEN

		for i in _lock_node_matrix.size():
			for lock in _lock_node_matrix[i]:
				lock.queue_free()

	elif locks_moved == true:
		select.emit()
		$Cursor.visible = true


func shuffle_matrix():
	var new_lock_position = $GateShape.position - Vector2(24.0, 24.0)
	var lock_i = 0
	var lock_array = [
		GateLock, GateLock, GateLock,
		GateLock, GateLock, GateLock,
		GateLock, GateLock, GateLock
	]

	for i in lock_array.size():
		if i < 3: 
			lock_array[i] = _gate_lock_red.instantiate()
		elif i >= 3 and i < 6:
			lock_array[i] = _gate_lock_green.instantiate()
		else:
			lock_array[i] = _gate_lock_blue.instantiate()

	lock_array.shuffle()

	while lock_i < lock_array.size():
		lock_array[lock_i].position = new_lock_position
		_lock_node_matrix[lock_i / 3][lock_i % 3] = lock_array[lock_i]
		lock_i += 1

		if lock_i % 3 == 0:
			new_lock_position.x -= 48
			new_lock_position.y += 24
		else: 
			new_lock_position.x += 24

	for row_i in _lock_node_matrix.size():
		for lock in _lock_node_matrix[row_i]:
			add_child(lock)
