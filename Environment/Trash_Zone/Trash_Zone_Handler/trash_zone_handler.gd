class_name TrashZoneHandler extends Node3D


var playerRef : Player
@onready var damagePlayerTimer : Timer = $DamagePlayerTimer
@onready var hitbox : HitboxComponent = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(_on_zone_area_entered)
	damagePlayerTimer.timeout.connect(_on_damgePlayerTimer_timeout)

func _on_zone_area_entered(area: Area3D) -> void:
	# turn off hitbox when we hit something and start timer
	if area is HurtboxComponent:
		damagePlayerTimer.start()
		hitbox.set_deferred("monitoring", false)

func _on_damgePlayerTimer_timeout() -> void:
	hitbox.set_deferred("monitoring", true)


func remove() -> void:
	pass
	#put functionality to remove the rash zone here
