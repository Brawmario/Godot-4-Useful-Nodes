class_name VerletRope
extends Line2D


@export var lenght := 500.0:
	set(value):
		lenght = value
		_update_segment_lenght()
@export var number_of_segments := 50:
	set(value):
		number_of_segments = value
		_update_segment_lenght()
		_reset()
@export var constraint_iterations := 10
@export var gravity := Vector2(0.0, 10.0)

var _current_points := PackedVector2Array()
var _old_points := PackedVector2Array()

var _segment_lenght: float


func _ready() -> void:
	_update_segment_lenght()
	_reset()


func _process(delta: float) -> void:
	_simulate(delta)
	for _i in range(constraint_iterations):
		_constrain()
	_commit()


func _reset() -> void:
	clear_points()
	for i in range(number_of_segments + 1):
		add_point(Vector2(0, _segment_lenght * i))

	_current_points.resize(get_point_count())
	for i in range(_current_points.size()):
		_current_points.set(i, to_global(points[i]))

	_old_points.clear()
	_old_points.append_array(_current_points)


func _simulate(delta: float) -> void:
	assert(_current_points.size() == _old_points.size())
	for i in range(_current_points.size()):
		var current_point := _current_points[i]
		var old_point := _old_points[i]
		var velocity := current_point - old_point

		_old_points.set(i, current_point)
		_current_points.set(i, current_point + velocity + gravity * delta)


func _constrain() -> void:
	var number_of_points := _current_points.size()
	if number_of_points < 2:
		if number_of_points == 1:
			_current_points.set(0, global_position)
		return

	_constrain_start()
	_constrain_middle()


func _commit() -> void:
	assert(_current_points.size() == get_point_count())
	for i in range(_current_points.size()):
		set_point_position(i, to_local(_current_points[i]))


func _constrain_start() -> void:
	_current_points.set(0, global_position)

	var first_point := _current_points[0]
	var second_point := _current_points[1]

	var change := _calculate_change_vector(first_point, second_point)

	_current_points.set(1, second_point + change)


func _constrain_middle() -> void:
	for i in range(1, _current_points.size() - 1):
		var first_point := _current_points[i]
		var second_point := _current_points[i + 1]

		var change := _calculate_change_vector(first_point, second_point)

		_current_points.set(i, first_point - change * 0.5)
		_current_points.set(i + 1, second_point + change * 0.5)


func _calculate_change_vector(first_point: Vector2, second_point: Vector2) -> Vector2:
	var distance := (first_point - second_point).length()
	var error := absf(distance - _segment_lenght)

	var change_direction: Vector2
	if distance > _segment_lenght:
		change_direction = (first_point - second_point).normalized()
	else:
		change_direction = (second_point - first_point).normalized()

	return change_direction * error


func _update_segment_lenght() -> void:
	_segment_lenght = lenght / float(number_of_segments)
