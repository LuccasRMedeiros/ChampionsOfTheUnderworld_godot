extends Node2D

enum GateState {LOCKED, OPEN}
enum CursorStates {SELECTING, MOVING}

var _next_warp = 24
var _loop_warp = -48
var _gate_state = GateState.LOCKED
var _cursor_state = CursorStates.SELECTING
var _cursor_rc = 1
var _lock_direction: GateLock.LockDirections
var _lock_matrix = [
	[Definitions.LockColors, Definitions.LockColors, Definitions.LockColors],
	[Definitions.LockColors, Definitions.LockColors, Definitions.LockColors],
	[Definitions.LockColors, Definitions.LockColors, Definitions.LockColors]
	]
var _lock_node_matrix = [
	[GateLock, GateLock, GateLock],
	[GateLock, GateLock, GateLock],
	[GateLock, GateLock, GateLock]
	]
var _lock_bckp: GateLock

@export var summon_direction: Definitions.Directions

var cursor_orientation = Definitions.CursorOrientations.HORIZONTAL

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

func move_locks(direction: GateLock.LockDirections):
	if direction == GateLock.LockDirections.LEFT:
		_lock_bckp = _lock_node_matrix[_cursor_rc][2]
		_lock_bckp.position.x -= 72
		add_child(_lock_bckp)

		_lock_bckp.set_end_position(direction)
		for lock in _lock_node_matrix[_cursor_rc]:
			lock.set_end_position(direction)

	elif direction == GateLock.LockDirections.RIGHT:
		_lock_bckp = _lock_node_matrix[_cursor_rc][0]
		_lock_bckp.position.x += 72
		add_child(_lock_bckp)

		_lock_bckp.set_end_position(direction)
		for lock in _lock_node_matrix[_cursor_rc]:
			lock.set_end_position(direction)

	elif direction == GateLock.LockDirections.DOWN:
		_lock_bckp = _lock_node_matrix[2][_cursor_rc]
		_lock_bckp.position.y -= 72
		add_child(_lock_bckp)

		_lock_bckp.set_end_position(direction)
		for lock_array in _lock_node_matrix:
			lock_array[_cursor_rc].set_end_position(direction)

	elif direction == GateLock.LockDirections.UP:
		_lock_bckp = _lock_node_matrix[0][_cursor_rc]
		_lock_bckp.position.y += 72
		add_child(_lock_bckp)

		_lock_bckp.set_end_position(direction)
		for lock_array in _lock_node_matrix:
			lock_array[_cursor_rc].set_end_direction(direction)

	_cursor_state = CursorStates.MOVING

func _changecursor_orientation():
	var position_bckp = $Cursor.position
	
	$Cursor.position.x = position_bckp.y
	$Cursor.position.y = position_bckp.x

	if cursor_orientation == Definitions.CursorOrientations.HORIZONTAL:
		$Cursor.rotation_degrees = 90.0
		cursor_orientation = Definitions.CursorOrientations.VERTICAL
	else:
		$Cursor.rotation_degrees = 0
		cursor_orientation = Definitions.CursorOrientations.HORIZONTAL

func shuffle_matrix():
	var lock_array = [
	Definitions.LockColors.RED, Definitions.LockColors.RED, Definitions.LockColors.RED,
	Definitions.LockColors.GREEN, Definitions.LockColors.GREEN, Definitions.LockColors.GREEN,
	Definitions.LockColors.BLUE, Definitions.LockColors.BLUE, Definitions.LockColors.BLUE
	]
	
	lock_array.shuffle()

	for i in lock_array.size():
		_lock_matrix[i % 3][i / 3] = lock_array[i]

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_lock: Node
	var new_lock_position = $GateShape.position - Vector2(24.0, -24.0)

	shuffle_matrix()

	for row_i in _lock_matrix.size():
		for column_i in _lock_matrix[row_i].size():
			match _lock_matrix[row_i][column_i]:
				Definitions.LockColors.RED:
					_lock_node_matrix[row_i][column_i] = preload("res://actors/common/Act_Common_RedLock.tscn").instantiate()

				Definitions.LockColors.GREEN:
					_lock_node_matrix[row_i][column_i] = preload("res://actors/common/Act_Common_GreenLock.tscn").instantiate()

				Definitions.LockColors.BLUE:
					_lock_node_matrix[row_i][column_i] = preload("res://actors/common/Act_Common_BlueLock.tscn").instantiate()

			_lock_node_matrix[row_i][column_i].position = new_lock_position
			add_child(_lock_node_matrix[row_i][column_i])

			new_lock_position.x += 24

		new_lock_position.x -= 72.0
		new_lock_position.y -= 24.0

func _process(delta):
	match _cursor_state:
		CursorStates.SELECTING:
			$Cursor.visible = true

		CursorStates.MOVING:
			$Cursor.visible = false
			if cursor_orientation == Definitions.CursorOrientations.HORIZONTAL:
				for lock in _lock_node_matrix[_cursor_rc]:
					lock.move(delta, cursor_orientation)

			else:
				for lock_array in _lock_node_matrix:
					lock_array[_cursor_rc].move(delta, cursor_orientation)
