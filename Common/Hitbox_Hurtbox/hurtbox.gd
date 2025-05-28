class_name HurtboxComponent extends Area3D

signal hurt(value)

func on_hurt(value : float) -> void:
	hurt.emit(value)
