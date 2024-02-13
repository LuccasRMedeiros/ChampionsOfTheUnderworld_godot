extends Node2D


enum CasterStates { READY, DRAWING, CASTING, COUNTDOWN }


var _caster_state = CasterStates.READY


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match _caster_state:
		CasterStates.READY:
			if Input.is_action_pressed("ui_click"):
				$Act_Common_CastingLine.clear_points()
				_caster_state = CasterStates.DRAWING

		CasterStates.DRAWING:
			if Input.is_action_pressed("ui_click"):
				$Act_Common_CastingLine.draw_rune(get_local_mouse_position())
			else:
				$Act_Common_CastingLine.comp_rune()
				_caster_state = CasterStates.READY


func _on_act_common_casting_line_rune_finished():
	_caster_state = CasterStates.CASTING


func _on_act_common_casting_line_rune_erased():
	_caster_state = CasterStates.READY
