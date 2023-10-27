extends Node2D

enum SummonerStates { PICKING, MOVING, SUMMONING }

var _state = SummonerStates.PICKING
var _lock_direction: GateLock.LockDirections

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match _state:
		SummonerStates.PICKING:
			if $Act_Common_SpawnGate.cursor_orientation == Definitions.CursorOrientations.HORIZONTAL:
				if Input.is_action_just_pressed("ui_down"):
					$Act_Common_SpawnGate.move_cursor(Definitions.CursorDirections.FORWARD)
				elif Input.is_action_just_pressed("ui_up"):
					$Act_Common_SpawnGate.move_cursor(Definitions.CursorDirections.BACKWARD)

				if Input.is_action_just_pressed("ui_right"):
					_lock_direction = GateLock.LockDirections.RIGHT
					$Act_Common_SpawnGate.set_locks_direction(_lock_direction)
					_state = SummonerStates.MOVING
				elif Input.is_action_just_pressed("ui_left"):
					_lock_direction = GateLock.LockDirections.LEFT
					$Act_Common_SpawnGate.set_locks_direction(_lock_direction)
					_state = SummonerStates.MOVING

			elif $Act_Common_SpawnGate.cursor_orientation == Definitions.CursorOrientations.VERTICAL:
				if Input.is_action_just_pressed("ui_right"):
					$Act_Common_SpawnGate.move_cursor(Definitions.CursorDirections.FORWARD)
				elif Input.is_action_just_pressed("ui_left"):
					$Act_Common_SpawnGate.move_cursor(Definitions.CursorDirections.BACKWARD)

				if Input.is_action_just_pressed("ui_down"):
					_lock_direction = GateLock.LockDirections.DOWN
					$Act_Common_SpawnGate.set_locks_direction(_lock_direction)
					_state = SummonerStates.MOVING
				elif Input.is_action_just_pressed("ui_up"):
					_lock_direction = GateLock.LockDirections.UP
					$Act_Common_SpawnGate.set_locks_direction(_lock_direction)
					_state = SummonerStates.MOVING

		SummonerStates.MOVING:
			$Act_Common_SpawnGate.move_locks(delta, _lock_direction)


func _on_act_common_spawn_gate_open_gate():
	_state = SummonerStates.SUMMONING


func _on_act_common_spawn_gate_close_gate():
	_state = SummonerStates.PICKING


func _on_act_common_spawn_gate_select():
	_state = SummonerStates.PICKING
