extends Node2D

enum SelectorDirection {FORWARD, BACKWARD}
enum Orientation {HORIZONTAL, VERTICAL}
enum GateState {LOCKED, OPEN}

var _current_orientation = Orientation.HORIZONTAL
var _warp_amount = 24
var _loop_warp = -48
var _gate_state = GateState.LOCKED
var _lock_array = [
	Definitions.LockColors.RED, Definitions.LockColors.RED, Definitions.LockColors.RED,
	Definitions.LockColors.GREEN, Definitions.LockColors.GREEN, Definitions.LockColors.GREEN,
	Definitions.LockColors.BLUE, Definitions.LockColors.BLUE, Definitions.LockColors.BLUE
	]
var _lock_matrix = [
	[Node, Node, Node],
	[Node, Node, Node],
	[Node, Node, Node]
	]

func move_selector(direction: SelectorDirection):
	if _current_orientation == Orientation.HORIZONTAL:
		if direction == SelectorDirection.FORWARD:
			$Selector.position.y += _warp_amount if $Selector.position.y < 24 else _loop_warp
		elif  direction == SelectorDirection.BACKWARD:
			$Selector.position.y -= _warp_amount if $Selector.position.y > -24 else _loop_warp
	elif _current_orientation == Orientation.VERTICAL:
		if direction == SelectorDirection.FORWARD:
			$Selector.position.x += _warp_amount if $Selector.position.x < 24 else _loop_warp
		elif direction == SelectorDirection.BACKWARD:
			$Selector.position.x -= _warp_amount if $Selector.position.x > -24 else _loop_warp

func change_selector_orientation():
	var position_bckp = $Selector.position
	
	$Selector.position.x = position_bckp.y
	$Selector.position.y = position_bckp.x

	if _current_orientation == Orientation.HORIZONTAL:
		$Selector.rotation_degrees = 90.0
		_current_orientation = Orientation.VERTICAL
	else:
		$Selector.rotation_degrees = 0
		_current_orientation = Orientation.HORIZONTAL

func get_selector_orientation() -> Orientation:
	return _current_orientation

func shuffle_matrix():
	_lock_array.shuffle()

	for i in _lock_array.size():
		_lock_matrix[i % 3][i / 3] = _lock_array[i]

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_lock: Node
	var new_lock_position = position - Vector2(24.0, 24.0)

	shuffle_matrix()

	for line in _lock_matrix:
		for lock in line:
			match lock:
				Definitions.LockColors.RED:
					new_lock = preload("res://actors/common/Act_Common_RedLock.tscn").instantiate()

				Definitions.LockColors.GREEN:
					new_lock = preload("res://actors/common/Act_Common_GreenLock.tscn").instantiate()

				Definitions.LockColors.BLUE:
					new_lock = preload("res://actors/common/Act_Common_BlueLock.tscn").instantiate()

			new_lock.position = new_lock_position
			add_child(new_lock)

			new_lock_position.x += 24
		
		new_lock_position.x -= 72.0
		new_lock_position.y -= 24.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
