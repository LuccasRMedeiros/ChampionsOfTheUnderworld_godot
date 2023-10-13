extends Node2D

var _spawn_number: int
var _spawn_delay: float
var _keys = [KEY_A, KEY_S, KEY_D]
var _random = RandomNumberGenerator.new()

func _assing_random_key():
	return _keys[_random.randi_range(0, 2)]

# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_number = 0
	_spawn_delay = 1.0 # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var daemon_hit_key = KEY_A

	_spawn_delay += delta

	if _spawn_delay >= 1.0 and _spawn_number < 3:
		var daemon = preload("res://actors/common/Act_Common_Daemon.tscn").instantiate()

		daemon.assingned_key = _assing_random_key()
		daemon.direction = Definitions.Directions.LEFT
		daemon.position.y = 32

		add_child(daemon)

		_spawn_delay = 0.0
		_spawn_number += 1

