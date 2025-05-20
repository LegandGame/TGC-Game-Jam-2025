class_name PlayerWalk extends PlayerState

func enter():
	pass

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(delta : float):
	# movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.cameraPivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = lerp(player.velocity.x, direction.x * player.speed, delta * player.groundAccel)
		player.velocity.z = lerp(player.velocity.z, direction.z * player.speed, delta * player.groundAccel)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, delta * player.groundAccel)
		player.velocity.z = lerp(player.velocity.z, 0.0, delta * player.groundAccel)
		# transition to idle
		if player.velocity.length_squared() < 0.1:
			transition.emit(self, "idle")
	
	# transition to jump
	if Input.is_action_just_pressed("jump"):
		transition.emit(self, "jump")
