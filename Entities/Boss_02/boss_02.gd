extends CharacterBody3D

@export var reward : PlayerState
var canReward : bool = true
@onready var interact : Area3D = $InteractArea
var canInteract : bool = false
var playerRef : Player

func _ready() -> void:
	interact.body_entered.connect(_on_interact_body_entered)
	interact.body_exited.connect(_on_interact_body_exited)

func _on_interact_body_entered(body : Node3D) -> void:
	if body is Player:
		canInteract = true
		playerRef = body
func _on_interact_body_exited(_body : Node3D) -> void:
	canInteract = false

func _input(event: InputEvent) -> void:
	if canInteract and event.is_action_pressed("interact") and playerRef and canReward:
		var newState = reward.duplicate()
		playerRef.stateMachine.add_child(newState)
		playerRef.add_state(newState)
		reward.queue_free()
		canReward = false
