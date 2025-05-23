extends Node3D

@onready var interact : Interactable = $Interactable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact.interact_online.connect(collect_seed)


func collect_seed(player : Node3D) -> void:
	player.seedTracker.add_seed()
	self.queue_free()
