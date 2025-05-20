class_name PlayerIdle extends PlayerState

func enter():
	pass

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(delta : float):
	# transition to movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.cameraPivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#print(direction)
	if direction:
		transition.emit(self, "walk")
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, delta * player.groundAccel)
		player.velocity.z = lerp(player.velocity.z, 0.0, delta * player.groundAccel)
	
	# transition to jump
	if Input.is_action_just_pressed("jump"):
		transition.emit(self, "jump")
