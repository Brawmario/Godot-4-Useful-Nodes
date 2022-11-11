class_name VerletRope
extends Line2D


@export var lenght := 500.0
@export var number_of_segments := 50
@export var constraint_iterations := 10
@export var gravity := Vector2(0.0, 10.0)

var _current_points: PackedVector2Array
var _old_points: PackedVector2Array

var segment_lenght: float


func _ready() -> void:
	segment_lenght = lenght / float(number_of_segments)

	clear_points()
	for i in range(number_of_segments + 1):
		add_point(Vector2(0, segment_lenght * i))

	_current_points = PackedVector2Array()
	_current_points.resize(get_point_count())
	for i in range(_current_points.size()):
		_current_points.set(i, to_global(points[i]))
	_old_points = _current_points.duplicate()


func _process(delta: float) -> void:
	_simulate(delta)
	for _i in range(constraint_iterations):
		_constrain()
	_commit()


func _simulate(delta: float) -> void:
	for i in range(_current_points.size()):
		var current_point := _current_points[i]
		var old_point := _old_points[i]
		var velocity := current_point - old_point

		_old_points.set(i, current_point)
		_current_points.set(i, current_point + velocity + gravity * delta)


func _constrain() -> void:
	if _current_points.size() < 1:
		return

	_constrain_start()
	_constrain_middle()


func _commit() -> void:
	for i in range(_current_points.size()):
		set_point_position(i, to_local(_current_points[i]))


func _constrain_start() -> void:
	_current_points.set(0, global_position)

	var first_point := _current_points[0]
	var second_point := _current_points[1]

	var change_direction := _get_change_direction(first_point, second_point)

	_current_points.set(1, second_point + change_direction)


func _constrain_middle() -> void:
	for i in range(1, _current_points.size() - 1):
		var first_point := _current_points[i]
		var second_point := _current_points[i + 1]

		var change_direction := _get_change_direction(first_point, second_point)

		_current_points.set(i, first_point - change_direction * 0.5)
		_current_points.set(i + 1, second_point + change_direction * 0.5)


func _get_change_direction(first_point: Vector2, second_point: Vector2) -> Vector2:
	var distance := (first_point - second_point).length()
	var error := absf(distance - segment_lenght)

	var change_direction: Vector2
	if distance > segment_lenght:
		change_direction = (first_point - second_point).normalized()
	else:
		change_direction = (second_point - first_point).normalized()
	change_direction *= error

	return change_direction
