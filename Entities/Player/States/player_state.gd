class_name PlayerState extends State

var player : Player

# TODO: question do I wanna put my player state helper functions in here?
# aka func get_input_direction(): and func lerp_player_velocity():

# STATE HELPER FUNCTIONS
func get_input_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.cameraPivot.transform.basis * Vector3(input_dir.x, 0.0, input_dir.y))
	# zero out the y value so that way the player's speed is independent of camera angle
	direction.y = 0.0
	direction = direction.normalized()
	return direction

func lerp_player_velocity(delta : float, direction : Vector3, speed : float, accel : float) -> void:
	player.velocity.x = lerp(player.velocity.x, direction.x * speed, delta * accel)
	player.velocity.z = lerp(player.velocity.z, direction.z * speed, delta * accel)
