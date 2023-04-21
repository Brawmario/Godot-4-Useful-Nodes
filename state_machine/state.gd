class_name State
extends Node


@onready var parent_state := get_parent() as State


func _ready() -> void:
	await owner.ready


func enter() -> void:
	if parent_state:
		parent_state.enter()


func exit() -> void:
	if parent_state:
		parent_state.exit()


func unhandled_input(event: InputEvent) -> State:
	if parent_state:
		return parent_state.unhandled_input(event)
	return null


func process(delta: float) -> State:
	if parent_state:
		return parent_state.process(delta)
	return null


func physics_process(delta: float) -> State:
	if parent_state:
		return parent_state.physics_process(delta)
	return null


func on_animation_finished(anim_name: StringName) -> State:
	if parent_state:
		return parent_state.on_animation_finished(anim_name)
	return null
