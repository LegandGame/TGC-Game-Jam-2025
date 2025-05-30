class_name PlayerSprint extends PlayerState

func enter():
	pass

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(delta : float):
	# transition to falling
	if !player.is_on_floor():
		transition.emit(self, "fall")
	
	# transition to walking
	if Input.is_action_just_pressed("sprint"):
		player.isSprinting = false
		transition.emit(self, "walk")
	
	# transition to jump
	if Input.is_action_just_pressed("jump"):
		transition.emit(self, "jump")
	
	# movement
	var direction := get_input_direction()
	if direction:
		lerp_player_velocity(delta, direction, player.sprintSpeed, player.groundAccel)
	else:
		lerp_player_velocity(delta, direction, 0.0, player.groundAccel)
		# transition to idle (length_squared() cause it's faster
		if player.velocity.length_squared() < 0.1:
			transition.emit(self, "idle")
	
