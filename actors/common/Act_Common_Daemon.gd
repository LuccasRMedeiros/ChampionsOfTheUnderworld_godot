extends Area2D

var CAN_BE_HIT: bool
var MOVE_SPEED = 300.0

@export var assingned_key: Key = KEY_A
@export var direction: Definitions.Directions = Definitions.Directions.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	MOVE_SPEED *= direction
	CAN_BE_HIT = false
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
	position.x += MOVE_SPEED * delta

	if CAN_BE_HIT and Input.is_key_pressed(assingned_key):
		queue_free()

func _on_body_entered(body):
	if body is Smasher:
		CAN_BE_HIT = true

func _on_body_exited(body):
	CAN_BE_HIT = false
