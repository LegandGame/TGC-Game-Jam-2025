class_name StateMachine extends Node

var states : Dictionary = {}
var curState : State
@export var initialState : State

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_upper()] = child
			child.transition.connect(on_state_transition)
	if initialState:
		initialState.enter()
		curState = initialState

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
