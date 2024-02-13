class_name Spawner


extends Node2D


enum DaemonDirections { RIGHT = -1, LEFT = 1 }


signal all_daemons_died


var _spawn_delay = 1.0
var _spawn_count = 0
var _keys = [KEY_A, KEY_S, KEY_D]
var _random = RandomNumberGenerator.new()
var _daemon = preload("res://actors/common/Act_Common_Daemon.tscn")


var direction: DaemonDirections


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn(delta) -> int:
	var daemon: Node
	var ret = 0

	_spawn_delay += delta

	if _spawn_delay >= 1.0:
		_spawn_count += 1
		daemon = _daemon.instantiate()

		daemon.has_died.connect(_on_daemon_died)
		daemon.assingned_key = _assing_random_key()
		daemon.direction = direction

		add_child(daemon)

		_spawn_delay = 0.0
		ret = 1

	return ret


func _assing_random_key() -> Key:
	return _keys[_random.randi_range(0, 2)]


func _on_daemon_died():
	_spawn_count -= 1

	if _spawn_count == 0:
		all_daemons_died.emit()
