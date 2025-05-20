class_name HurtboxComponent extends Area3D

signal hurt(value)

func on_hurt(value : int) -> void:
	hurt.emit(value)
