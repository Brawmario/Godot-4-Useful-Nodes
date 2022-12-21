class_name State
extends Node


var parent_state := get_parent() as State


func _ready() -> void:
	await owner.ready


func enter() -> void:
	pass


func exit() -> void:
	pass


func unhandled_input(event: InputEvent) -> State:
	return null


func process(delta: float) -> State:
	return null


func physics_process(delta: float) -> State:
	return null


func on_animation_finished(anim_name: String) -> State:
	return null
