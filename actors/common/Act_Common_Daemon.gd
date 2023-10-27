extends Area2D


signal has_died


var _can_be_destroyied: bool
var _move_speed = 300.0


@export var assingned_key: Key = KEY_A
@export var direction: Definitions.Directions = Definitions.Directions.RIGHT


# Called when the node enters the scene tree for the first time.
func _ready():
	_move_speed *= direction
	_can_be_destroyied = false
	$CollisionShape2D.position.x *= direction
	
	match assingned_key:
		KEY_A:
			$DaemonSkinA.visible = true
		KEY_S:
			$DaemonSkinS.visible = true
		KEY_D:
			$DaemonSkinD.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += _move_speed * delta

	if _can_be_destroyied and Input.is_key_pressed(assingned_key):
		queue_free()


func _on_body_entered(body):
	if body is Smasher:
		_can_be_destroyied = true


func _on_body_exited(body):
	_can_be_destroyied = false
