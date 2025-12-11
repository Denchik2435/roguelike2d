extends State

var collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func physics_update(_delta):

	if actor is Hero:
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


func enter():
	collected = false
	actor.play_anim("collect", collect)


func collect():
	if collected:
		return
	else:
		collected = true
		Global.take_soul.emit()
		actor.play_effects("collect")
		actor.play_sound("collect")
		
