extends StaticBody3D

@onready var interact : Interactable = $Interactable
@onready var label : Label3D = $Label3D
var canInteract : bool = false	# is the player in range to interact?
var isHolding : bool = false	# are we already holding a seed?
@export var canRetrieve : bool = true	# are we allowing the player to retrieve a seed>
var playerRef : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact.interact_online.connect(enable_deposit)
	interact.interact_offline.connect(disable_deposit)
	label.hide()

func enable_deposit(body : Node3D) -> void:
	canInteract = true
	label.show()
	if body is Player:
		playerRef = body
func disable_deposit(_body : Node3D) -> void:
	canInteract = false
	label.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and canInteract:
		if not isHolding and playerRef.seedTracker.seedCount > 0:
			playerRef.seedTracker.remove_seed()
			isHolding = true
		elif isHolding and canRetrieve:
			playerRef.seedTracker.add_seed()
			isHolding = false
		disable_deposit(playerRef)
