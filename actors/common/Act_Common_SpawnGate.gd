extends Node2D

enum SelectorDirection {FORWARD, BACKWARD}
enum Orientation {HORIZONTAL, VERTICAL}
enum GateState {LOCKED, OPEN}

var _current_orientation = Orientation.HORIZONTAL
var _warp_amount = 24
var _loop_warp = -48
var _gate_state = GateState.LOCKED
var _lock_array = []

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
