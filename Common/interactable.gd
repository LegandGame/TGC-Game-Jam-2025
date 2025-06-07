class_name Interactable extends Area3D

signal interact_online(body)
signal interact_offline(body)
var canInteract : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body : Node3D) -> void:
	if body is Player:
		interact_online.emit(body)
		canInteract = true

func _on_body_exited(body : Node3D) -> void:
	if body is Player:
		interact_offline.emit(body)
		canInteract = false
