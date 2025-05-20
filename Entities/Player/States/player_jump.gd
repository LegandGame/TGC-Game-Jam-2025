class_name PlayerJump extends PlayerState

func enter():
	player.velocity.y = player.jumpForce

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(delta : float):
	if player.is_on_floor():
		transition.emit(self, "idle")
	
	# apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = min(player.velocity.y, player.terminalVelo)
	
	# air movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.cameraPivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = lerp(player.velocity.x, direction.x * player.speed, delta * player.airAccel)
		player.velocity.z = lerp(player.velocity.z, direction.z * player.speed, delta * player.airAccel)
