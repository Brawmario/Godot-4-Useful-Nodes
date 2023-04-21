class_name StateMachine
extends Node


signal state_changed(state: State)

@export var state: State
@export var animation_player: AnimationPlayer


func _ready() -> void:
	await owner.ready

	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)

	assert(state, "Initial state not set")
	state.enter()


func _unhandled_input(event: InputEvent) -> void:
	var next_state := state.unhandled_input(event)
	if next_state:
		transition_to(next_state)


func _process(delta: float) -> void:
	var next_state := state.process(delta)
	if next_state:
		transition_to(next_state)


func _physics_process(delta: float) -> void:
	var next_state := state.physics_process(delta)
	if next_state:
		transition_to(next_state)


func _on_animation_finished(anim_name: StringName) -> void:
	var next_state := state.on_animation_finished(anim_name)
	if next_state:
		transition_to(next_state)


func transition_to(next_state: State) -> void:
	state.exit()
	state = next_state
	state.enter()
	state_changed.emit(state)
