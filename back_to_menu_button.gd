extends Button


func _on_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://main.tscn"))
