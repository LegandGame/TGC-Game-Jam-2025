class_name PlayerFall extends PlayerState

func enter():
	pass

func exit():
	# emit dust particles here
	pass

func update(_delta : float):
	pass

func physics_update(delta : float):
	# transition to idle
	if player.is_on_floor():
		transition.emit(self, "idle")
	
	# apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = min(player.velocity.y, player.terminalVelo)
	
	# transition to jump
	if Input.is_action_just_pressed("jump") and player.canDoubleJump:
		transition.emit(self, "doublejump")
	
	if Input.is_action_just_pressed("sprint") and player.canAirDash:
		transition.emit(self, "dash")
	
	# air movement
	var direction := get_input_direction()
	if direction:
		lerp_player_velocity(delta, direction, player.walkSpeed, player.airAccel)
