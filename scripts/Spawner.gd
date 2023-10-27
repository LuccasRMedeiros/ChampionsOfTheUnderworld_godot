class_name Spawner


extends Node2D


enum DaemonDirections { RIGHT = -1, LEFT = 1 }


var _spawn_number = 0
var _spawn_delay = 1.0
var _keys = [KEY_A, KEY_S, KEY_D]
var _random = RandomNumberGenerator.new()
var _daemon = preload("res://actors/common/Act_Common_Daemon.tscn")


var direction: DaemonDirections


func _assing_random_key() -> Key:
	return _keys[_random.randi_range(0, 2)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn(delta) -> int:
	var daemon_hit_key: Key
	var daemon: Node

	_spawn_delay += delta

	if _spawn_delay >= 1.0 and _spawn_number < 3:
		daemon = _daemon.instantiate()

		daemon.assingned_key = _assing_random_key()
		daemon.direction = direction
#		daemon.position.y = 24

		add_child(daemon)

		_spawn_delay = 0.0
		_spawn_number += 1

	return _spawn_number


func reset_spawn_number():
	_spawn_number = 0
