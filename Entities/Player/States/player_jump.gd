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
	
	if player.velocity.y <= 0.0:
		transition.emit(self, "fall")
	
	if Input.is_action_just_pressed("sprint") and player.canAirDash:
		transition.emit(self, "dash")
	
	# apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = min(player.velocity.y, player.terminalVelo)
	
	# air movement
	var direction := get_input_direction()
	if direction:
		lerp_player_velocity(delta, direction, player.walkSpeed, player.airAccel)
