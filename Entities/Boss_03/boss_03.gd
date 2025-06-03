extends CharacterBody3D

@export var endScene : PackedScene
@onready var interact : Area3D = $InteractArea
var canInteract : bool = false

func _ready() -> void:
	interact.body_entered.connect(_on_interact_body_entered)
	interact.body_exited.connect(_on_interact_body_exited)

func _on_interact_body_entered(body : Node3D) -> void:
	if body is Player:
		canInteract = true
func _on_interact_body_exited(_body : Node3D) -> void:
	canInteract = false

func _input(event: InputEvent) -> void:
	if canInteract and event.is_action_pressed("interact") and endScene:
		get_tree().change_scene_to_packed(endScene)
