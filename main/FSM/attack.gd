extends State

@onready var can_move = false

func enter(msg = {}):
	actor.anim.play("attack")
	if actor.is_in_group("player"):
		can_move = true

func physics_update(delta):
	# дозволяємо рух як у MoveState
	if can_move:
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

		# Поворот спрайта
		if dir.x != 0:
			actor.get_node("Face").scale.x = -1 if dir.x < 0 else 1

func _on_attack_frame():
	if actor.has_method("attack"):
		actor.attack()

func exit():
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	actor.fsm.change_to("Move")
