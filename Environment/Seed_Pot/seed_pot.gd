extends StaticBody3D

@onready var interact : Interactable = $Interactable
@onready var safeZone : Area3D = $SafetyArea
@onready var seedScene := preload("res://Environment/Seed/seed.tscn")
@onready var plantModel := $Plant
var canInteract : bool = false	# is the player in range to interact?
var isHolding : bool = false	# are we already holding a seed?
@export var canRetrieve : bool = true	# are we allowing the player to retrieve a seed>
@export var safeZoneRadius : float = 1.0	# in meters
var playerRef : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact.interact_online.connect(enable_deposit)
	interact.interact_offline.connect(disable_deposit)
	safeZone.body_entered.connect(_on_safe_zone_entered)
	safeZone.body_exited.connect(_on_safe_zone_exited)
	$SafetyArea/CollisionShape3D.shape.radius = safeZoneRadius
	plantModel.hide()

func enable_deposit(body : Node3D) -> void:
	canInteract = true
	if body is Player:
		playerRef = body
func disable_deposit(_body : Node3D) -> void:
	canInteract = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and canInteract:
		# place a seed
		if not isHolding and playerRef.seedTracker.seedCount > 0:
			playerRef.seedTracker.remove_seed()
			add_to_group("checkpoint")
			isHolding = true
			plantModel.show()
			# enable safe zone
			safeZone.set_deferred("monitorable", true)
			safeZone.set_deferred("monitoring", true)
		# remove a seed
		elif isHolding and canRetrieve:
			#spawn the seed
			var newSeed = seedScene.instantiate()
			newSeed.position = self.position + Vector3(0.0, 2.5, 0.0)
			get_parent().add_child(newSeed)
			# remove as checkpoint
			remove_from_group("checkpoint")
			isHolding = false
			plantModel.hide()
			# disable safe zone
			safeZone.set_deferred("monitorable", false)
			safeZone.set_deferred("monitoring", false)
		disable_deposit(playerRef)


func _on_safe_zone_entered(body : Node3D) -> void:
	if body is Player:
		print("player is safe")
		body.hurtbox.set_deferred("monitorable", false)
		body.hurtbox.set_deferred("monitoring", false)

func _on_safe_zone_exited(body : Node3D) -> void:
	if body is Player:
		print("player is not safe")
		body.hurtbox.set_deferred("monitorable", true)
		body.hurtbox.set_deferred("monitoring", true)
