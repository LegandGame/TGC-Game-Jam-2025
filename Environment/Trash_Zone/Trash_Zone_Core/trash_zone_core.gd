class_name TrashZoneCore extends Node3D

@onready var interact : Interactable = $InteractArea
@onready var health : HealthComponent = $HealthComponent
var drainRate : float = 1.0
var maxHealth : float = 1.0

signal cleansed(core : TrashZoneCore)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.health_empty.connect(remove)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if interact.canInteract and Input.is_action_pressed("interact"):
		health.change_cur_health(-drainRate * delta)

func remove() -> void:
	cleansed.emit(self)
	queue_free()
