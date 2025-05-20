class_name HitboxComponent extends Area3D

@export var value : int = -1	# use negative values to deal damage. positive to heal

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area is HurtboxComponent:
		area.on_hurt(value)
