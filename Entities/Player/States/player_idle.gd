class_name PlayerIdle extends PlayerState

func enter():
	player.canDoubleJump = true
	player.canAirDash = true

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(delta : float):
	# transition to falling
	if !player.is_on_floor():
		transition.emit(self, "fall")
	
	# toggle sprinting
	if Input.is_action_just_pressed("sprint"):
		player.isSprinting = !player.isSprinting
		
	# transition to movement
	var direction := get_input_direction()
	if direction:
		if player.isSprinting:
			transition.emit(self, "sprint")
		else:
			transition.emit(self, "walk")
	else:
		lerp_player_velocity(delta, direction, 0.0, player.groundAccel)
	
	# transition to jump
	if Input.is_action_just_pressed("jump"):
		transition.emit(self, "jump")
