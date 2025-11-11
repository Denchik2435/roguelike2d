extends State

func physics_update(delta):
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1

	dir = dir.normalized()
	actor.velocity = dir * actor.speed
	actor.move_and_slide()
	
	actor.anim.play("idle")

	if dir.x != 0:
		actor.get_node("Face").scale.x = -1 if dir.x < 0 else 1

	if Input.is_action_pressed("mouse_0"):
		actor.fsm.change_to("Attack")
