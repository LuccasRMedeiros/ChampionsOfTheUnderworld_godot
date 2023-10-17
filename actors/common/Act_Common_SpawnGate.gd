extends Node2D

enum GateState {LOCKED, OPEN}
enum CursorStates {SELECTING, MOVING}
enum CursorDirections {FORWARD, BACKWARD}
enum CursorOrientations {HORIZONTAL, VERTICAL}

var _next_warp = 24
var _loop_warp = -48
var _gate_state = GateState.LOCKED
var _cursor_state = CursorStates.SELECTING
var _lock_matrix = [
	[Definitions, Definitions, Definitions],
	[Definitions, Definitions, Definitions],
	[Definitions, Definitions, Definitions]
	]
var _lock_node_matrix = [
	[GateLock, GateLock, GateLock],
	[GateLock, GateLock, GateLock],
	[GateLock, GateLock, GateLock]
	]

var cursor_orientation = CursorOrientations.HORIZONTAL
var rc_position = 1

func move_cursor(direction: CursorDirections):
	var cursor_warp: Vector2
	var warp_amount = _next_warp

	if direction == CursorDirections.FORWARD:
		rc_position = rc_position + 1 

		if rc_position == 3:
			rc_position = 0
			warp_amount = _loop_warp
		
		warp_amount *= -1

	elif direction == CursorDirections.BACKWARD:
		rc_position = rc_position - 1
		
		if rc_position == -1:
			rc_position = 2
			warp_amount = _loop_warp

	if cursor_orientation == CursorOrientations.HORIZONTAL:
		cursor_warp = Vector2(0.0, float(warp_amount))
	elif cursor_orientation == CursorOrientations.VERTICAL:
		cursor_warp = Vector2(float(warp_amount), 0.0)

	$Cursor.position -= cursor_warp

func change_cursor_orientation():
	var position_bckp = $Cursor.position
	
	$Cursor.position.x = position_bckp.y
	$Cursor.position.y = position_bckp.x

	if cursor_orientation == CursorOrientations.HORIZONTAL:
		$Cursor.rotation_degrees = 90.0
		cursor_orientation = CursorOrientations.VERTICAL
	else:
		$Cursor.rotation_degrees = 0
		cursor_orientation = CursorOrientations.HORIZONTAL

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
