extends Polygon2D

@export var lock_color: Definitions.LockColors

# Called when the node enters the scene tree for the first time.
func _ready():
	match lock_color:
		Definitions.LockColors.RED:
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
