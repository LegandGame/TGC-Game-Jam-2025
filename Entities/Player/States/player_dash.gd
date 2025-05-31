class_name PlayerDash extends PlayerState

func enter():
	player.canAirDash = false
	#actually perform the dash
	#var dashDir = -player.transform.basis.z.normalized()
	var dashDir = player.lastMovementDir
	player.velocity = dashDir * player.dashForce
	player.velocity.y = 0

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(delta : float):
	if player.is_on_floor():
		transition.emit(self, "idle")
	
	# air movement
	lerp_player_velocity(delta, player.lastMovementDir, player.walkSpeed, player.airAccel)
	#var direction := get_input_direction()
	#if direction:
		#lerp_player_velocity(delta, direction, player.walkSpeed, player.airAccel)
	#else:
		#lerp_player_velocity(delta, direction, 0.0, player.airAccel)
	
	await get_tree().create_timer(player.dashDuration).timeout
	transition.emit(self, "fall")
