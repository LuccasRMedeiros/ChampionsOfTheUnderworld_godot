extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		$Act_Common_SpawnGate.move_cursor(Definitions.CursorDirections.FORWARD)
	elif Input.is_action_just_pressed("ui_up"):
		$Act_Common_SpawnGate.move_cursor(Definitions.CursorDirections.BACKWARD)
