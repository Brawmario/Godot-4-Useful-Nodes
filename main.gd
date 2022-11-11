extends Control


func _on_verlet_rope_demo_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://verlet_rope/verlet_rope_demo.tscn"))
