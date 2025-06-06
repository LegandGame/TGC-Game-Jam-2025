class_name StateMachine extends Node

var states : Dictionary = {}
var curState : State
@export var animator : AnimationPlayer
@export var initialState : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_upper()] = child
			child.transition.connect(on_state_transition)
	if initialState:
		# need this await here or any references to our parent won't be ready in time for initialState.enter()
		await get_parent().ready
		initialState.enter()
		curState = initialState
		play_state_anim(curState)

func add_state(newState : State) -> void:
	states[newState.name.to_upper()] = newState
	newState.transition.connect(on_state_transition)

func _process(delta: float) -> void:
	if curState:
		curState.update(delta)

func _physics_process(delta: float) -> void:
	if curState:
		curState.physics_update(delta)

func on_state_transition(calling_state : State, new_state_name : String):
	if calling_state != curState:
		return
	
	var new_state = states.get(new_state_name.to_upper())
	if !new_state:
		return
	
	if curState:
		curState.exit()
	new_state.enter()
	curState = new_state
	play_state_anim(curState)

func play_state_anim(state : State) -> void:
	if !animator or !animator.has_animation(state.name.to_upper()):
		return
	animator.play(state.name.to_upper())
