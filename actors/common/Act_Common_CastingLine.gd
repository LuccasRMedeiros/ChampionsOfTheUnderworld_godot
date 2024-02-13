extends Line2D


enum MagicTypes { INVALID = -1, WIND, THUNDER, FIRE }


enum _Travel { DISTANCE, ANGLE }
enum _RunePoints { WIND = 3, THUNDER = 4, FIRE = 5 }


signal rune_finished
signal rune_erased
signal is_thunder
signal is_fire
signal is_ice


#Let the player draw a line
func draw_rune(point_position: Vector2):
	var distance: float = point_position.distance_to(get_point_position(get_point_count() - 1))

	if distance > 5.00:
		add_point(point_position)


# Compare the form drawed by the player
func comp_rune() -> int:
	var main_points: Array = [get_point_position(0)]
	var last_point: Vector2 = get_point_position(1)
	var last_angle: float = main_points[0].angle_to_point(last_point)

	for i in range(2, get_point_count() - 1):
		var point: Vector2 = get_point_position(i)
		var angle: float = last_point.angle_to_point(point)

		if last_angle - angle > 0.5 or last_angle - angle < -0.5:
#			print("New Line")
			main_points.append(point)

#		print(angle)
		last_point = point
		last_angle = angle

	main_points.append(get_point_position(get_point_count() - 1))
	_redraw_line(main_points)

	match main_points.size():
		_RunePoints.WIND:
			print("Wind: ", main_points[0].angle_to(main_points[2]))

		_RunePoints.THUNDER:
			print("Thunder: ", main_points[0].angle_to(main_points[2]), " ", main_points[1].angle_to(main_points[3]))

		_RunePoints.FIRE:
			print("Fire: ", main_points[0].angle_to(main_points[2]), " ", main_points[1].angle_to(main_points[3]), " ", main_points[2].angle_to(main_points[4]))

	return MagicTypes.INVALID


# Debug the normalized line
func _redraw_line(points: Array):
	clear_points()

	for point in points:
		add_point(point)

	print("Point count: ", get_point_count())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
