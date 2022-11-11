extends Node2D


@onready var verlet_rope := $VerletRope as VerletRope


func _process(delta: float) -> void:
	verlet_rope.global_position = get_global_mouse_position()
