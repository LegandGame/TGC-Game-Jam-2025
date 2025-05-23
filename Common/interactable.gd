class_name Interactable extends Area3D

signal interact_online(body)
signal interact_offline(body)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body : Node3D) -> void:
	if body.is_in_group("player"):
		interact_online.emit(body)

func _on_body_exited(body : Node3D) -> void:
	if body.is_in_group("player"):
		interact_offline.emit(body)
