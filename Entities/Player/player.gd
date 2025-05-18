class_name Player extends CharacterBody3D

var mouseSensitivity := 0.25
var cameraInputDir := Vector2.ZERO
var invertMouseDirY := true
var invertMouseDirX := false

# NODE REFERENCES
@onready var cameraPivot : Node3D = $CameraPivot
@onready var camera : Camera3D = $CameraPivot/SpringArm3D/Camera3D

@export_category("Properties")
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	# CAMERA
	cameraPivot.rotation.x += cameraInputDir.y * delta
	cameraPivot.rotation.x = clamp(cameraPivot.rotation.x, deg_to_rad(-80), deg_to_rad(30))
	cameraPivot.rotation.y -= cameraInputDir.x * delta
	cameraInputDir = Vector2.ZERO
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# JUMPING
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# MOVEMENT
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (cameraPivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
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
