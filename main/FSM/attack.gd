extends State

@onready var player = false

func enter():

	if actor.is_in_group("player"):
		player = true
	actor.anim.play("attack")
	actor.anim.connect("frame_changed", Callable(self, "attack"))


func physics_update(_delta):
	# дозволяємо рух як у MoveState
	if player:
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


func attack():
	if actor.anim.frame == actor.attack_frame:
		actor.do_attack()

func exit():
	actor.anim.disconnect("frame_changed", Callable(self, "attack"))
