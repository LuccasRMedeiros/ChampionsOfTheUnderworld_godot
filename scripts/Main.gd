extends Node

var _random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_random.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
