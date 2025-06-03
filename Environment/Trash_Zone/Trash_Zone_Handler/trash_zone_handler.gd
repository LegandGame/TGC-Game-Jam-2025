class_name TrashZoneHandler extends Node3D


var playerRef : Player
@onready var damagePlayerTimer : Timer = $DamagePlayerTimer
@onready var hitbox : HitboxComponent = $Hitbox
var cores : Array[TrashZoneCore]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(_on_zone_area_entered)
	damagePlayerTimer.timeout.connect(_on_damgePlayerTimer_timeout)
	for child in get_children():
		if child is TrashZoneCore:
			cores.append(child)
			child.cleansed.connect(update_core_count)

func _on_zone_area_entered(area: Area3D) -> void:
	# turn off hitbox when we hit something and start timer
	if area is HurtboxComponent:
		damagePlayerTimer.start()
		hitbox.set_deferred("monitoring", false)

func _on_damgePlayerTimer_timeout() -> void:
	hitbox.set_deferred("monitoring", true)


func update_core_count(called_core : TrashZoneCore) -> void:
	if called_core in cores:
		cores.erase(called_core)
	if len(cores) == 0:
		remove()

func remove() -> void:
	queue_free()
