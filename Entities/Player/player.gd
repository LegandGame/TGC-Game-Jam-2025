class_name Player extends CharacterBody3D

# NODE REFERENCES
@onready var cameraPivot : Node3D = $CameraPivot
@onready var camera : Camera3D = $CameraPivot/SpringArm3D/Camera3D
@onready var cameraSpringArm : SpringArm3D = $CameraPivot/SpringArm3D
@onready var stateMachine : StateMachine = $StateMachine
@onready var hurtbox : HurtboxComponent = $Hurtbox
@onready var seedTracker := $SeedTracker
@onready var health : HealthComponent = $SeedTracker/Health
@onready var combatTimer : Timer = $CombatTimer
@onready var playerMesh := $Moth

@export_category("Movement")
@export var walkSpeed : float = 5.0
@export var sprintSpeed : float = 8.0
@export var jumpForce : float = 4.5
@export var dashForce : float = 12.0
@export var dashDuration : float = 0.8	# seconds
@export var groundAccel : float = 6.0
@export var airAccel : float = 2.0
@export var gravity : float = -9.8
@export var terminalVelo : float = 30.0
@export var rotationSpeed : float = 12.0

@export_category("Camera")
@export var mouseSensitivity := 0.25
@export var fov := 95.0
var cameraInputDir := Vector2.ZERO
var invertMouseDirY := true
var invertMouseDirX := false

@export_category("Properties")
@export var healRate : float = 0.5

var isSprinting : bool
var canDoubleJump : bool = true
var canAirDash : bool = true
var outOfCombat : bool = true
var lastMovementDir := Vector3.BACK


func _ready() -> void:
	# change camera fov
	camera.fov = fov
	# initialize player states
	for state in stateMachine.states.values():
		state.player = self
	# connect health
	hurtbox.hurt.connect(take_damage)
	health.health_empty.connect(respawn)
	# connect combat timer
	combatTimer.timeout.connect(_on_combat_timer_timeout)
	# capture player mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func add_state(state : PlayerState) -> void:
	state.player = self
	stateMachine.add_state(state)

func _physics_process(delta: float) -> void:
	# DEBUG LABELS TEMPORARY
	$DebugStateLabel.text = stateMachine.curState.name
	$DebugHealthLabel.text = str(health.get_max_health(), "/", health.get_cur_health())
	# CAMERA (state independent)
	cameraPivot.rotation.x += cameraInputDir.y * delta
	cameraPivot.rotation.x = clamp(cameraPivot.rotation.x, deg_to_rad(-80), deg_to_rad(30))
	cameraPivot.rotation.y -= cameraInputDir.x * delta
	cameraInputDir = Vector2.ZERO
	
	# heal out of combat
	if outOfCombat:
		health.change_cur_health(healRate * delta)
	
	# zoom in and out
	var scroll = Input.get_axis("scroll_down", "scroll_up")
	if scroll:
		cameraSpringArm.spring_length += scroll * delta * 2.0
		cameraSpringArm.spring_length = clamp(cameraSpringArm.spring_length, 2.0, 10.0)
	
	# rotate character
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (cameraPivot.transform.basis * Vector3(input_dir.x, 0.0, input_dir.y))
	direction.y = 0.0
	direction = direction.normalized()
	if direction.length_squared() > 0.2:
		lastMovementDir = direction
	var targetAngle := Vector3.BACK.signed_angle_to(lastMovementDir, Vector3.UP)
	playerMesh.global_rotation.y = lerp_angle(
		playerMesh.rotation.y, targetAngle, rotationSpeed * delta
		)
	
	move_and_slide()


# Capture & De-capture mouse
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# get CameraInputDir
func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		cameraInputDir = event.screen_relative * mouseSensitivity
		if invertMouseDirY:
			cameraInputDir.y = -event.screen_relative.y * mouseSensitivity
		if invertMouseDirX:
			cameraInputDir.x = -event.screen_relative.x * mouseSensitivity


func take_damage(damage : float) -> void:
	health.change_cur_health(damage)
	outOfCombat = false
	combatTimer.start()

func _on_combat_timer_timeout() -> void:
	outOfCombat = true

func respawn() -> void:
	var buffer := Vector3(0, 2.5, 0)
	health.reset_health()
	# find the nearest checkpoint
	var nearestCheckpoint = null
	var nearestCheckpointDistance = INF
	for c in get_tree().get_nodes_in_group("checkpoint"):
		if position.distance_squared_to(c.position) < nearestCheckpointDistance:
			nearestCheckpointDistance = c.position
			nearestCheckpoint = c
	#respawn
	if nearestCheckpoint:
		position = nearestCheckpoint.global_position + buffer
	else:
		position = Vector3(0.0, 2.5, 0.0)
